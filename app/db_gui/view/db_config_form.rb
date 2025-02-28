require 'db_gui/model/db_config'

class DbGui
  module View
    class DbConfigForm
      include Glimmer::LibUI::CustomControl
      
      option :db_config
      
      body {
        vertical_box {
          form {
            entry {
              label 'Host:'
              text <=> [db_config, :host]
            }
            
            spinbox(0, 1_000_000) {
              label 'Port:'
              value <=> [db_config, :port]
            }
            
            entry {
              label 'Database Name:'
              text <=> [db_config, :dbname]
            }
            
            entry {
              label 'Username:'
              text <=> [db_config, :username]
            }
            
            password_entry {
              label 'Password:'
              text <=> [db_config, :password]
            }
          }
          
          button {
            stretchy false
            text <= [db_config, :connected, on_read: -> (connected) { connected ? 'Disconnect (currently connected)' : 'Connect (currently disconnected)' }]
              
            on_clicked do
              db_config.toggle_connection
            end
          }
        }
      }
    end
  end
end
