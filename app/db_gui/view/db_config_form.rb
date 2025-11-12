require 'db_gui/model/db'

class DbGui
  module View
    class DbConfigForm
      include Glimmer::LibUI::CustomControl
      
      option :db_presenter
      
      body {
        vertical_box {
          form {
            # TODO consider switching to editable_combobox to enter new value and save in the same control
            # TODO fix issue with current design using combobox before refactoring to editable_combobox
            combobox { |me|
              label 'Selected Config:'
              items <= [db_presenter, :dbs, on_read: ->(dbs) { pd dbs.map(&:name) }]
              selected_item <=> [db_presenter, :selected_db_name,
#                                   on_read: -> (val) {pd val},
#                                   on_write: -> (val) {pd me.selected_item; pd val},
#                                   after_write: -> {pd me.selected_item},
                                ]
#               selected <=> [db_presenter, :selected_db_name,
#                                   on_read: -> (val) {pd db_presenter.dbs.map(&:name).index(val)},
#                                   on_write: -> (val) {pd val; db_presenter.dbs[val].name},
#                                 ]
#               on_selected do |c|
#                 pd "New combobox selection: #{c.selected}"
#               end
            }
            
            entry {
              label 'Host:'
              text <=> [db_presenter, 'selected_db.host']
              enabled <= [db_presenter, 'selected_db.connected', on_read: :!]
            }
            
            spinbox(0, 1_000_000) {
              label 'Port:'
              value <=> [db_presenter, 'selected_db.port']
              enabled <= [db_presenter, 'selected_db.connected', on_read: :!]
            }
            
            entry {
              label 'Database Name:'
              text <=> [db_presenter, 'selected_db.dbname']
              enabled <= [db_presenter, 'selected_db.connected', on_read: :!]
            }
            
            entry {
              label 'Username:'
              text <=> [db_presenter, 'selected_db.username']
              enabled <= [db_presenter, 'selected_db.connected', on_read: :!]
            }
            
            password_entry {
              label 'Password:'
              text <=> [db_presenter, 'selected_db.password']
              enabled <= [db_presenter, 'selected_db.connected', on_read: :!]
            }
            
            horizontal_box {
              entry {
                text <=> [db_presenter, 'selected_db.name']
              }
              button {
                stretchy false
                text 'Save'
                enabled <= [db_presenter, 'selected_db.saveable']
                
                on_clicked do
                  db_presenter.save
                end
              }
              button {
                stretchy false
                text 'Delete'
                enabled <= [db_presenter, 'selected_db.deleteable']
                
                on_clicked do
                  db_presenter.delete
                end
              }
              button {
                stretchy false
                text 'New'
                enabled <= [db_presenter, 'newable']
                
                on_clicked do
                  db_presenter.new
                end
              }
            }
          }
          
          button {
            stretchy false
            text <= [db_presenter, 'selected_db.connected', on_read: -> (connected) { connected ? 'Disconnect (currently connected)' : 'Connect (currently disconnected)' }]
              
            on_clicked do
              db_presenter.selected_db.toggle_connection
            end
          }
        }
      }
    end
  end
end
