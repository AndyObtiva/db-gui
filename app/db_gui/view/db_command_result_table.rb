require 'db_gui/model/db_config'

class DbGui
  module View
    class DbCommandResultTable
      include Glimmer::LibUI::CustomControl
      
      option :db_config
      
      body {
        vertical_box {
          content(db_config, :db_command_result) {
            if db_config.db_command_result_count > 0
              table {
                db_config.db_command_result_headers.each do |header|
                  text_column(header)
                end
                
                cell_rows db_config.db_command_result_rows
              }
            else
              label('No data')
            end
          }
        }
      }
    end
  end
end
            
