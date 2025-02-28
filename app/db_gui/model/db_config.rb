class DbGui
  module Model
    DbConfig = Struct.new(:host, :port, :dbname, :username, :password, keyword_init: true) do
      attr_accessor :connected
      alias connected? connected
    
      def initialize
        self.port = 5432 # PostgreSQL default port
      end
      
      def toggle_connection
        if connected?
          disconnect
        else
          connect
        end
      end
      
      def connect
        # TODO must create a command line session for:
        # psql --host= --port= --username= --dbname=
        # and must enter password when prompted
        self.connected = true
      end
      
      def disconnect
        self.connected = false
      end
    end
  end
end
