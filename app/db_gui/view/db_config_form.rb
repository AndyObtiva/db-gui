require 'db_gui/model/db'

class DbGui
  module View
    class DbConfigForm
      include Glimmer::LibUI::CustomControl
      
      option :db
      
      body {
        vertical_box {
          form {
            entry {
              label 'Host:'
              text <=> [db, :host]
              enabled <= [db, :connected, on_read: :!]
            }
            
            spinbox(0, 1_000_000) {
              label 'Port:'
              value <=> [db, :port]
              enabled <= [db, :connected, on_read: :!]
            }
            
            entry {
              label 'Database Name:'
              text <=> [db, :dbname]
              enabled <= [db, :connected, on_read: :!]
            }
            
            entry {
              label 'Username:'
              text <=> [db, :username]
              enabled <= [db, :connected, on_read: :!]
            }
            
            password_entry {
              label 'Password:'
              text <=> [db, :password]
              enabled <= [db, :connected, on_read: :!]
            }
          }
          
          button {
            stretchy false
            text <= [db, :connected, on_read: -> (connected) { connected ? 'Disconnect (currently connected)' : 'Connect (currently disconnected)' }]
              
            on_clicked do
              db.toggle_connection
            end
          }
        }
      }
    end
  end
end
