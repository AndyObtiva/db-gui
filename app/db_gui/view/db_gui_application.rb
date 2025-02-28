require 'db_gui/presenter/db_gui_presenter'

require 'db_gui/view/db_config_form'
require 'db_gui/view/db_command_form'

class DbGui
  module View
    class DbGuiApplication
      include Glimmer::LibUI::Application
    
      attr_reader :presenter
          
      before_body do
        @presenter = Presenter::DbGuiPresenter.new
#         menu_bar # TODO implement
      end
  
      body {
        window {
          content_size 1024, 800
          title 'DB GUI'
          
          margined true
         
          vertical_box {
            db_config_form(db_config: presenter.db_config) {
              stretchy false
            }
            
            db_command_form(db_config: presenter.db_config)
            
            non_wrapping_multiline_entry {
              text <=> [presenter.db_config, :db_command_result, on_write: ->(value) {presenter.db_config.db_command_result}]
            }
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
