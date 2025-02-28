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
              enabled <= [db_config, :connected, on_read: :!]
            }
            
            spinbox(0, 1_000_000) {
              label 'Port:'
              value <=> [db_config, :port]
              enabled <= [db_config, :connected, on_read: :!]
            }
            
            entry {
              label 'Database Name:'
              text <=> [db_config, :dbname]
              enabled <= [db_config, :connected, on_read: :!]
            }
            
            entry {
              label 'Username:'
              text <=> [db_config, :username]
              enabled <= [db_config, :connected, on_read: :!]
            }
            
            password_entry {
              label 'Password:'
              text <=> [db_config, :password]
              enabled <= [db_config, :connected, on_read: :!]
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
