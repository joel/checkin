require 'rubygems'
require 'spork'

Spork.prefork do
  
  if ENV['CODE_COVERAGE'] == '1'
    require 'simplecov'
    SimpleCov.start 'rails'
  end
  # require 'cover_me' # Ruby 1.9
    
  ENV["RAILS_ENV"] ||= 'test'
  require 'rails/application'
  Spork.trap_method(Rails::Application, :reload_routes!)
  
  require File.expand_path("../../config/environment", __FILE__)
  require 'rspec/rails'
  require 'factory_girl'
  # https://github.com/irohiroki/guard-spork-ruby-debug-sample
  require 'spork/ext/ruby-debug'
  require 'database_cleaner'

  Dir[Rails.root.join("spec/support/**/*.rb")].each {|f| require f}
  Dir[Rails.root.join("lib/**/*.rb")].each {|f| require f}

  RSpec.configure do |config|
    config.mock_with :mocha
    config.mock_with :rspec

    config.include Devise::TestHelpers, :type => :controller
    config.include Devise::TestHelpers, :type => :view
    config.include Devise::TestHelpers, :type => :helper
    config.include ControllerMacros, :type => :controller
    config.include ControllerMacros, :type => :view
    config.include ControllerMacros, :type => :helper

    config.use_transactional_fixtures = false
    
    config.before(:all) do
      DeferredGarbageCollection.start
    end

    config.after(:all) do
      DeferredGarbageCollection.reconsider
    end
    
  end

end

Spork.each_run do

end
