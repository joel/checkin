#!/usr/bin/env rake
# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require File.expand_path('../config/application', __FILE__)
unless Rails.env.production?
  require 'rake'
  require 'rspec/core'
  require 'rspec/core/rake_task'
end
CheckinReloaded::Application.load_tasks
