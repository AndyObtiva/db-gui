require 'db_gui/model/db_config'

class DbGui
  module View
    class DbCommandForm
      include Glimmer::LibUI::CustomControl
      
      option :db_config
      
      body {
        vertical_box {
          entry {
            text <=> [db_config, :db_command]
          }
          
          horizontal_box {
            stretchy false
          
            button('Run') {
              on_clicked do
                db_config.run_db_command
              end
            }
            
            label('Timeout (msec): ') {
              stretchy false
            }
            spinbox(0, 60000) {
              stretchy false
              value <=> [db_config, :db_command_timeout]
            }
          }
        }
      }
    end
  end
end
