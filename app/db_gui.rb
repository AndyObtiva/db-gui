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
end

require 'db_gui/view/db_gui_application.rb'
