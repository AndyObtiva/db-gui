require 'db_gui/model/db'

class DbGui
  module Presenter
    class DbPresenter
      attr_accessor :dbs, :selected_db, :new_db
      
      def initialize
        @new_db = Model::Db.new
        @dbs = [@new_db]
        @selected_db = @new_db
      end
      
      def newable
        selected_db != new_db
      end
      
      def selected_db_name
        selected_db.name
      end
      
      def selected_db_name=(db_name)
        self.selected_db = dbs.find { |db| db.name == db_name }
        notify_observers(:newable)
      end
      
      def save
        # TODO validate that name is NOT NAME_NEW
        if selected_db == new_db && selected_db.name != Model::Db::NAME_NEW
          saved_db = new_db.clone
          new_db.reset
          dbs << saved_db # this will trigger an update to the combobox items
          self.selected_db_name = saved_db.name
        else
          notify_observers(:dbs)
          self.selected_db_name = selected_db.name
        end
        # save config in selected db
        # TODO disconnect if needed
        # TODO reconnect if needed
      end
      
      def new
        self.selected_db_name = new_db.name
      end
      
      def delete
        dbs.delete(selected_db)
        self.selected_db_name = new_db.name
      end
      
      # TODO loading/saving to file
    end
  end
end
