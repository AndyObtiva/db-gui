class DbGui
  module Model
    # TODO consider renaming to DB connection
    DbConfig = Struct.new(:host, :port, :dbname, :username, :password, keyword_init: true) do
      FILE_DB_CONFIG = File.expand_path(File.join('~', '.db_gui'))
      
      attr_accessor :connected
      alias connected? connected
      attr_accessor :console
    
      def initialize
        self.port = 5432 # PostgreSQL default port
        self.console = ''
        load_db_config
        connect if to_a.none? {|value| value.nil? || (value.respond_to?(:empty?) && value.empty?) }
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
      
      def io_command(command)
        @io_command_try ||= 0
        @io_command_try += 1
        io.puts(command)
      rescue Errno::EPIPE => e
        @io = nil
        io_command(command) unless @io_command_try > 1
      end
      
      def io_append_response_to_console
        while line = io.gets
          self.console << line
        end
      rescue Errno::EPIPE => e
        @io = nil
      end
      
      private
      
      def save_db_config
        db_config_hash = to_h
        db_config_file_content = YAML.dump(db_config_hash)
        File.write(FILE_DB_CONFIG, db_config_file_content)
      end
      
      def load_db_config
        db_config_file_content = File.read(FILE_DB_CONFIG)
        db_config_hash = YAML.load(db_config_file_content)
        db_config_hash.each do |attribute, value|
          self.send("#{attribute}=", value)
        end
      rescue => e
        puts "No database configuration is stored yet. #{e.message}"
      end
    end
  end
end
