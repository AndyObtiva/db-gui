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
          
          button('Run') {
            stretchy false
              
            on_clicked do
              db_config.run_db_command
            end
          }
        }
      }
    end
  end
end
