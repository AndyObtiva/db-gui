require 'db_gui/model/db_config'

class DbGui
  module Presenter
    class DbGuiPresenter
      attr_reader :db_config
      
      def initialize
        @db_config = Model::DbConfig.new
      end
    end
  end
end
