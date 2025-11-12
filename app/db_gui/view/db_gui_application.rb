require 'db_gui/presenter/db_presenter'

require 'db_gui/view/db_gui_menu_bar'
require 'db_gui/view/db_config_form'
require 'db_gui/view/db_command_form'
require 'db_gui/view/db_command_result_table'

class DbGui
  module View
    class DbGuiApplication
      include Glimmer::LibUI::Application
    
      attr_reader :db_presenter
          
      before_body do
        @db_presenter = Presenter::DbPresenter.new
        db_gui_menu_bar(db_presenter:)
      end
  
      body {
        window {
          content_size 1024, 800
          title 'DB GUI'
          
          margined true
         
          vertical_box {
            db_config_form(db_presenter:) {
              stretchy false
            }
            
            db_command_form(db_presenter:)
            
            db_command_result_table(db_presenter:)
          }
        }
      }
    end
  end
end
