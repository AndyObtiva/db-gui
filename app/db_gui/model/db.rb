require 'fileutils'
require 'timeout'

class DbGui
  module Model
    Db = Struct.new(:host, :port, :dbname, :username, :password, keyword_init: true) do
      DIR_DB_GUI = File.expand_path(File.join('~', '.db_gui'))
      FileUtils.rm(DIR_DB_GUI) if File.file?(DIR_DB_GUI)
      FileUtils.mkdir_p(DIR_DB_GUI)
      FILE_DB_CONFIGS = File.expand_path(File.join(DIR_DB_GUI, '.db_configs'))
      FILE_DB_COMMANDS = File.expand_path(File.join(DIR_DB_GUI, '.db_commands'))
      
      attr_accessor :connected
      alias connected? connected
      attr_accessor :db_command_result
      attr_accessor :db_command
      attr_accessor :db_command_timeout
    
      def initialize
        self.port = 5432 # PostgreSQL default port
        self.db_command_result = ''
        self.db_command_timeout = (ENV['DB_COMMAND_TIMEOUT_IN_MILLISECONDS'] || 300).to_i
        load_db_config
        load_db_command
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
        @io ||= IO.popen("PGPASSWORD=\"#{password}\" psql --host=#{host} --port=#{port} --username=#{username} --dbname=#{dbname}", 'r+')
      end
      
      def run_io_command(command)
        command = command.strip
        command = "#{command};" unless command.end_with?(';')
        @io_command_try ||= 0
        @io_command_try += 1
        io.puts(command)
        read_io_into_db_command_result
      rescue Errno::EPIPE => e
        @io = nil
        run_io_command(command) unless @io_command_try > 1
      end
      
      def run_db_command
        run_io_command(db_command)
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
      
      private
      
      def read_io_into_db_command_result
        self.db_command_result = ''
        while (line = io_gets)
          result = line.to_s
          self.db_command_result += result
        end
      rescue Errno::EPIPE => e
        @io = nil
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
        # TODO figure out a way of knowing the end of input without timing out
        Timeout.timeout(db_command_timeout/1000.0) { io.gets }
      rescue
        @io = nil
        nil
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
        db_command_result_lines = db_command_result.lines
        db_command_result_lines.pop if db_command_result_lines.last == "\n"
        if db_command_result_lines.any?
          headers = db_command_result_lines.first.split('|').map(&:strip)
          count_footer = db_command_result_lines.last
          count_match = count_footer.match(/^\((\d+) row/)
          if count_match
            count = count_match[1].to_i
            rows = db_command_result_lines[2..-2].map {|row| row.split('|').map(&:strip) }
          end
        end
        [count, headers, rows]
      end
    end
  end
end
