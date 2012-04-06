# $:.unshift(File.expand_path('./lib', ENV['rvm_path']||="~/.rvm"))
# $:.unshift(File.expand_path('./lib', '~/.rvm/bin/rvm-shell'))
$:.unshift(File.expand_path('./lib', ENV['rvm_path']))

require "rvm/capistrano"

# Default sets
set :application, "checkin_#{ENV['name']}_#{rails_env}" # checkin_tau_production
set :thin_service_name, "thin_checkin_#{ENV['name']}_prod-0" # thin_checkin_tau_prod-0
set :resque_service_name, "resque_checkin_#{ENV['name']}_prod" # resque_checkin_tau_prod

set :user, "capistrano"

# RVM
set :rvm_ruby_string, 'ruby-1.9.2-p290'
set :rvm_type, :user # ~/.rvm/bin/rvm-shell instead /usr/local/rvm/bin/rvm-shell

# Assets
set :normalize_asset_timestamps, false
