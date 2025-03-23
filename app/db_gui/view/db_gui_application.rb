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
#         menu_bar # TODO implement
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
  
#       def menu_bar
#         menu('File') {
#           menu_item('Preferences...') {
#             on_clicked do
#               display_preferences_dialog
#             end
#           }
#
#           quit_menu_item if OS.mac?
#         }
#         menu('Help') {
#           if OS.mac?
#             about_menu_item {
#               on_clicked do
#                 display_about_dialog
#               end
#             }
#           end
#
#           menu_item('About') {
#             on_clicked do
#               display_about_dialog
#             end
#           }
#         }
#       end
#
#       def display_about_dialog
#         message = "Db Gui #{VERSION}\n\n#{LICENSE}"
#         msg_box('About', message)
#       end
#
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
