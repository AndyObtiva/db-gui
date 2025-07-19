require 'db_gui/model/db'

require 'db_gui/view/db_gui_menu_bar'
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
        db_gui_menu_bar(db:)
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
    end
  end
end
