require 'glimmer/data_binding/observable_model'
require 'db_gui/model/db'

class DbGui
  module Presenter
    class DbPresenter
      include Glimmer::DataBinding::ObservableModel
      
      attr_accessor :dbs, :selected_db, :new_db
      
      def initialize
        @new_db = Model::Db.new
        @dbs = [@new_db]
        @selected_db = @new_db
        load_db_config
        selected_db.connect
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
        save_config
      end
      
      def save
        if selected_db == new_db && selected_db.name != Model::Db::NAME_NEW
          saved_db = new_db.clone
          new_db.reset
          dbs << saved_db # this will trigger an update to the combobox items
          self.selected_db_name = saved_db.name
        else
          notify_observers(:dbs)
          self.selected_db_name = selected_db.name
        end
        save_config
      end
      
      def new
        self.selected_db_name = new_db.name
      end
      
      def delete
        dbs.delete(selected_db)
        self.selected_db_name = new_db.name
      end
      
      def save_config
        dbs_attributes = dbs.reject {|db| db.name == Model::Db::NAME_NEW }.map(&:to_h)
        selected_db_name
        db_config = {
          selected_db_name:,
          dbs: dbs_attributes,
        }
        db_config_yaml = YAML.dump(db_config)
        File.write(FILE_DB_CONFIGS, db_config_yaml)
      end
      
      def load_db_config
        db_config_yaml = File.read(FILE_DB_CONFIGS)
        db_config = YAML.load(db_config_yaml)
        db_config[:dbs].each do |db_config|
          db = Model::Db.new
          db_config.each do |attribute, value|
            db.send("#{attribute}=", value)
          end
          self.dbs << db
        end
        self.selected_db_name = db_config[:selected_db_name]
      rescue => e
        puts "No database configurations stored yet. #{e.message}"
      end
      
    end
  end
end
