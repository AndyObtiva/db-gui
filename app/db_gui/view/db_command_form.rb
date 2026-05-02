require 'db_gui/model/db'

class DbGui
  module View
    class DbCommandForm
      include Glimmer::LibUI::CustomControl
      
      TIMEOUT_MAX_IN_MILLISECONDS = (ENV['TIMEOUT_MAX_IN_MILLISECONDS'] || 60*60*1000).to_i
      
      option :db_presenter
      
      body {
        vertical_box {
          horizontal_box {
            stretchy false
            combobox {
              items <= [db_presenter, 'selected_db.db_commands']
              selected_item <=> [db_presenter, 'selected_db.db_command']
              enabled <= [db_presenter, 'selected_db.db_commands', on_read: -> (value) { value != [''] }]
            }
            button('Remove') {
              stretchy false
              on_clicked do
                db_presenter.selected_db.remove_db_command
              end
            }
            button('Clear') {
              stretchy false
              on_clicked do
                db_presenter.selected_db.clear_db_commands
              end
            }
          }
          non_wrapping_multiline_entry {
            text <=> [db_presenter, 'selected_db.db_command']
          }
          horizontal_box {
            stretchy false
          
            button('Run') {
              enabled <= [db_presenter, 'selected_db.db_command', on_read: -> (command) { !command.to_s.strip.empty? }]
              
              on_clicked do
                db_presenter.selected_db.run_db_command
              end
            }
                        
            label('Timeout (msec): ') {
              stretchy false
            }
            spinbox(0, TIMEOUT_MAX_IN_MILLISECONDS) {
              stretchy false
              value <=> [db_presenter, 'selected_db.db_command_timeout', on_read: :to_i]
            }
            
            label('Rows: ') {
              stretchy false
            }
            label {
              stretchy false
              text <= [db_presenter, 'selected_db.db_command_result_count', computed_by: 'selected_db.db_command_result', on_read: :to_s]
            }
          }
        }
      }
    end
  end
end
