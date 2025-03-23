# Generated by juwelier
# DO NOT EDIT THIS FILE DIRECTLY
# Instead, edit Juwelier::Tasks in Rakefile, and run 'rake gemspec'
# -*- encoding: utf-8 -*-
# stub: db-gui 0.1.0 ruby lib app

Gem::Specification.new do |s|
  s.name = "db-gui".freeze
  s.version = "0.1.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib".freeze, "app".freeze]
  s.authors = ["Andy Maleh".freeze]
  s.date = "2025-03-23"
  s.description = "DB GUI (Database Graphical User Interface) - Enables Interaction with Relational SQL Databases".freeze
  s.email = "andy.am@gmail.com".freeze
  s.executables = ["db-gui".freeze, "dbgui".freeze, "db-ui".freeze, "dbui".freeze]
  s.extra_rdoc_files = [
    "CHANGELOG.md",
    "LICENSE.txt",
    "README.md"
  ]
  s.files = [
    "LICENSE.txt",
    "VERSION",
    "app/db-gui.rb",
    "app/db_gui/launch.rb",
    "app/db_gui/model/db.rb",
    "app/db_gui/view/db_command_form.rb",
    "app/db_gui/view/db_command_result_table.rb",
    "app/db_gui/view/db_config_form.rb",
    "app/db_gui/view/db_gui_application.rb",
    "bin/db-gui",
    "bin/db-ui",
    "bin/dbgui",
    "bin/dbui",
    "icons/linux/Db Gui.png",
    "icons/macosx/Db Gui.icns",
    "icons/windows/Db Gui.ico"
  ]
  s.homepage = "http://github.com/AndyObtiva/db-gui".freeze
  s.licenses = ["MIT".freeze]
  s.rubygems_version = "3.4.19".freeze
  s.summary = "DB GUI".freeze

  s.specification_version = 4

  s.add_runtime_dependency(%q<glimmer-dsl-libui>.freeze, ["~> 0.12.7"])
  s.add_development_dependency(%q<rspec>.freeze, ["~> 3.5.0"])
  s.add_development_dependency(%q<juwelier>.freeze, ["= 2.4.9"])
  s.add_development_dependency(%q<simplecov>.freeze, [">= 0"])
end

