require 'db_gui/model/db'

require 'db_gui/view/db_config_form'
require 'db_gui/view/db_command_form'
require 'db_gui/view/db_command_result_table'

class DbGui
  module View
    class DbGuiApplication
      include Glimmer::LibUI::Application
    
      attr_reader :db
          
      before_body do
        @db = Model::Db.new
        menu_bar
      end
  
      body {
        window {
          content_size 1024, 800
          title 'DB GUI'
          
          margined true
         
          vertical_box {
            db_config_form(db:) {
              stretchy false
            }
            
            db_command_form(db:)
            
            db_command_result_table(db:)
          }
        }
      }
  
      def menu_bar
        menu('Edit') {
          menu_item('Copy Table') {
            enabled <= [db, :db_command_result_rows, computed_by: :db_command_result, on_read: -> (data) { !data.empty? }]
            
            on_clicked do
              db.copy_table
            end
          }

          menu_item('Copy Table (without headers)') {
            enabled <= [db, :db_command_result_rows, computed_by: :db_command_result, on_read: -> (data) { !data.empty? }]
            
            on_clicked do
              db.copy_table_without_headers
            end
          }

          menu_item('Copy Selected Row') {
            enabled <= [db, :db_command_result_rows, computed_by: :db_command_result, on_read: -> (data) { !data.empty? }]
            
            on_clicked do
              db.copy_selected_row
            end
          }

          menu_item('Copy Selected Row (without headers)') {
            enabled <= [db, :db_command_result_rows, computed_by: :db_command_result, on_read: -> (data) { !data.empty? }]
            
            on_clicked do
              db.copy_selected_row_without_headers
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
      end

      def display_about_dialog
        message = "DB GUI #{VERSION}\n\n#{LICENSE}"
        msg_box('About', message)
      end

#       def display_preferences_dialog
#         window {
#           title 'Preferences'
#           content_size 200, 100
#
#           margined true
#
#           vertical_box {
#             padded true
#
#             label('Greeting:') {
#               stretchy false
#             }
#
#             radio_buttons {
#               stretchy false
#
#               items Model::Greeting::GREETINGS
#               selected <=> [@greeting, :text_index]
#             }
#           }
#         }.show
#       end
    end
  end
end
