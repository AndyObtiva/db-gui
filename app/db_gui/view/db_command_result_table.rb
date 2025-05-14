require 'db_gui/model/db'

class DbGui
  module View
    class DbCommandResultTable
      include Glimmer::LibUI::CustomControl
      
      option :db
      
      body {
        vertical_box {
          content(db, :db_command_result) {
            if db.db_command_result_error?
              label(db.db_command_result)
            elsif db.db_command_result_count > 0
              table {
                db.db_command_result_headers.each do |header|
                  text_column(header)
                end
                
                cell_rows db.db_command_result_rows
                selection_mode :one
                selection db.db_command_result_selection
                
                on_selection_changed do |t, selection, added_selection, removed_selection|
                  db.db_command_result_selection = selection
                end
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
            
