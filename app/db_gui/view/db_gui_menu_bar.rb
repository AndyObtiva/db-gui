class DbGui
  module View
    class DbGuiMenuBar
      include Glimmer::LibUI::CustomControl
  
      option :db
  
      body {
        menu('Query') {
          menu_item('Run') {
            on_clicked do
              db.run_db_command
            end
          }
        }
        
        menu('Edit') {
          menu_item('Copy Table') {
            enabled <= [db, :db_command_result_rows, computed_by: :db_command_result, on_read: -> (data) { !data.empty? }]
            
            on_clicked do
              db.copy_table
            end
          }

          menu_item('Copy Table (with headers)') {
            enabled <= [db, :db_command_result_rows, computed_by: :db_command_result, on_read: -> (data) { !data.empty? }]
            
            on_clicked do
              db.copy_table_with_headers
            end
          }

          menu_item('Copy Table (with query & headers)') {
            enabled <= [db, :db_command_result_rows, computed_by: :db_command_result, on_read: -> (data) { !data.empty? }]
            
            on_clicked do
              db.copy_table_with_query_and_headers
            end
          }

          menu_item('Copy Selected Row') {
            enabled <= [db, :db_command_result_rows, computed_by: :db_command_result, on_read: -> (data) { !data.empty? }]
            
            on_clicked do
              db.copy_selected_row
            end
          }

          menu_item('Copy Selected Row (with headers)') {
            enabled <= [db, :db_command_result_rows, computed_by: :db_command_result, on_read: -> (data) { !data.empty? }]
            
            on_clicked do
              db.copy_selected_row_with_headers
            end
          }

          quit_menu_item if OS.mac?
        }
        menu('Help') {
          if OS.mac?
            about_menu_item {
              on_clicked do
                display_about_dialog
              end
            }
          end

          menu_item('About') {
            on_clicked do
              display_about_dialog
            end
          }
        }
      }
    end
  
    def display_about_dialog
      message = "DB GUI #{VERSION}\n\n#{LICENSE}"
      msg_box('About', message)
    end
  end
end
