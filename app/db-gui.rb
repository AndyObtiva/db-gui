$LOAD_PATH.unshift(File.expand_path('..', __FILE__))

begin
  require 'bundler/setup'
  Bundler.require(:default)
rescue Exception
  # this runs when packaged as a gem (no bundler)
  require 'glimmer-dsl-libui'
  # add more gems if needed
end

class DbGui
  APP_ROOT = File.expand_path('../..', __FILE__)
  VERSION = File.read(File.join(APP_ROOT, 'VERSION'))
  LICENSE = File.read(File.join(APP_ROOT, 'LICENSE.txt'))
  DIR_DB_GUI = File.expand_path(File.join('~', '.db_gui'))
  FileUtils.rm(DIR_DB_GUI) if File.file?(DIR_DB_GUI)
  FileUtils.mkdir_p(DIR_DB_GUI)
  FILE_DB_CONFIGS = File.expand_path(File.join(DIR_DB_GUI, '.db_config'))
  FILE_DB_COMMANDS = File.expand_path(File.join(DIR_DB_GUI, '.db_commands'))
end

require 'db_gui/view/db_gui_application.rb'
