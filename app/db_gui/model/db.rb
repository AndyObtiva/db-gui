require 'fileutils'
require 'timeout'
require 'clipboard'

class DbGui
  module Model
    Db = Struct.new(:host, :port, :dbname, :username, :password, :db_command_timeout, keyword_init: true) do
      DIR_DB_GUI = File.expand_path(File.join('~', '.db_gui'))
      FileUtils.rm(DIR_DB_GUI) if File.file?(DIR_DB_GUI)
      FileUtils.mkdir_p(DIR_DB_GUI)
      FILE_DB_CONFIGS = File.expand_path(File.join(DIR_DB_GUI, '.db_configs'))
      FILE_DB_COMMANDS = File.expand_path(File.join(DIR_DB_GUI, '.db_commands'))
      COUNT_RETRIES = ENV.fetch('DB_COMMAND_COUNT_RETRIES', 7)
      REGEX_ROW_COUNT = /^\((\d+) row/
      ERROR_PREFIX = 'ERROR:'
      NEW_LINE = OS.windows? ? "\r\n" : "\n"
      
      attr_accessor :connected
      alias connected? connected
      attr_accessor :db_command_result
      attr_accessor :db_command
      attr_accessor :db_command_result_selection
    
      def initialize
        load_db_config
        load_db_command
        self.port ||= 5432 # PostgreSQL default port
        self.db_command_result = ''
        self.db_command_timeout ||= ENV.fetch('DB_COMMAND_TIMEOUT_IN_MILLISECONDS', 300).to_i
        self.db_command_result_selection = 0
        connect if to_h.except(:password).none? {|value| value.nil? || (value.respond_to?(:empty?) && value.empty?) }
      end
      
      def toggle_connection
        if connected?
          disconnect
        else
          connect
        end
      end
      
      def connect
        io
        self.connected = true
        save_db_config
      end
      
      def disconnect
        io.close
        @io = nil
        self.connected = false
      end
      
      def io
        db_connection_command = "PGPASSWORD=\"#{password}\" psql --host=#{host} --port=#{port} --username=#{username} --dbname=#{dbname}"
        @io ||= IO.popen(db_connection_command, 'r+', err: [:child, :out])
      end
      
      def run_io_command(command)
        command = command.strip
        command = "#{command};" unless command.end_with?(';')
        @io_command_try ||= 0
        @io_command_try += 1
        io.puts(command)
        read_io_into_db_command_result
        @io_command_try = nil
      rescue Timeout::Error, Errno::EPIPE => e
        puts e.message
        @io = nil
        if @io_command_try > COUNT_RETRIES
          @io_command_try = nil
        else
          self.db_command_timeout *= 2
          puts "Retrying DB Command...  {try: #{@io_command_try + 1}, db_command_timeout: #{db_command_timeout}}"
          run_io_command(command) unless db_command_result_error?
        end
      end
      
      def run_db_command
        run_io_command(db_command)
        save_db_config
        save_db_command
      end
      
      def db_command_result_count
        db_command_result_count_headers_rows[0]
      end
      
      def db_command_result_headers
        db_command_result_count_headers_rows[1]
      end
      
      def db_command_result_rows
        db_command_result_count_headers_rows[2]
      end
      
      def db_command_result_error?
        db_command_result.to_s.strip.start_with?(ERROR_PREFIX)
      end
      
      def copy_table
        return if db_command_result_rows.empty?
        Clipboard.copy(formatted_table_string)
      end
      
      def copy_selected_row
        return if db_command_result_rows.empty?
        Clipboard.copy(formatted_selected_row_string)
      end
      
      def formatted_table_string
        column_max_lengths = db_command_result_column_max_lengths
        db_command_result_rows.map do |row|
          row.each_with_index.map do |data, column_index|
            data.ljust(column_max_lengths[column_index])
          end.join(" | ")
        end.join(NEW_LINE)
      end
      
      def formatted_selected_row_string
        selected_row = db_command_result_rows[db_command_result_selection]
        selected_row.join(' | ')
      end
      
      private
      
      def read_io_into_db_command_result
        self.db_command_result = read_db_command_result = ''
        while (!(@line.to_s.match(REGEX_ROW_COUNT) || @line.to_s.strip == "^") && (@line = io_gets))
          read_db_command_result += @line.to_s
        end
        self.db_command_result = read_db_command_result
      rescue
        if read_db_command_result.to_s.strip.start_with?(ERROR_PREFIX)
          self.db_command_result = read_db_command_result
        else
          raise
        end
      ensure
        @line = nil
      end
      
      def save_db_config
        db_config_hash = to_h
        db_configs_array = [db_config_hash] # TODO in the future, support storing multiple DB configs
        db_configs_file_content = YAML.dump(db_configs_array)
        File.write(FILE_DB_CONFIGS, db_configs_file_content)
      end
      
      def load_db_config
        db_configs_file_content = File.read(FILE_DB_CONFIGS)
        db_configs_array = [YAML.load(db_configs_file_content)].flatten
        db_config_hash = db_configs_array.first # TODO in the future, support loading multiple DB configs
        db_config_hash.each do |attribute, value|
          self.send("#{attribute}=", value)
        end
      rescue => e
        puts "No database configurations stored yet. #{e.message}"
      end
      
      def save_db_command
        db_commands_array = [db_command] # TODO in the future, support storing multiple DB configs
        db_commands_file_content = YAML.dump(db_commands_array)
        File.write(FILE_DB_COMMANDS, db_commands_file_content)
      end
      
      def load_db_command
        db_commands_file_content = File.read(FILE_DB_COMMANDS)
        db_commands_array = YAML.load(db_commands_file_content)
        self.db_command = db_commands_array.first
      rescue => e
        puts "No database commands stored yet. #{e.message}"
      end
      
      def io_gets
        Timeout.timeout(db_command_timeout/1000.0) { io.gets }
      rescue
        @io = nil
        raise
      end
      
      def db_command_result_count_headers_rows
        if @db_command_result_count_headers_rows.nil? || db_command_result != @last_db_command_result
          @db_command_result_count_headers_rows = compute_db_command_result_count_headers_rows
          @last_db_command_result = db_command_result
        end
        @db_command_result_count_headers_rows
      end
      
      def compute_db_command_result_count_headers_rows
        count = 0
        headers = rows = []
        db_command_result_lines = db_command_result.lines.reject { |line| line == "\n" }
        if db_command_result_lines.any?
          headers = db_command_result_lines.first.split('|').map(&:strip)
          count_footer = db_command_result_lines.last
          count_match = count_footer.match(REGEX_ROW_COUNT)
          if count_match
            count = count_match[1].to_i
            rows = db_command_result_lines[2..-2].map {|row| row.split('|').map(&:strip) }
          end
        end
        [count, headers, rows]
      end
      
      def db_command_result_column_max_lengths
        column_count = db_command_result_rows.first.size
        column_max_lengths = []
        db_command_result_rows.each do |row|
          row.each_with_index do |value, column_index|
            column_max_lengths[column_index] ||= 0
            column_max_lengths[column_index] = [column_max_lengths[column_index], value.size].max
          end
        end
        column_max_lengths
      end
    end
  end
end
