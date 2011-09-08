require 'rubygems'
require 'spork'

Spork.prefork do
  
  if ENV['CODE_COVERAGE'] == '1'
    require 'simplecov'
    SimpleCov.start 'rails'
  end
  
  ENV["RAILS_ENV"] ||= 'test'
  require 'rails/application'
  Spork.trap_method(Rails::Application, :reload_routes!)
  
  require File.expand_path("../../config/environment", __FILE__)
  require 'rspec/rails'
  require 'factory_girl'
  require 'spork/ext/ruby-debug'
  # require 'cover_me' # Ruby 1.9

  require File.dirname(__FILE__) + "/custom_matchers"
  require File.dirname(__FILE__) + "/controller_macros"
  
  Dir[Rails.root.join("spec/support/**/*.rb")].each {|f| require f}
  Dir[Rails.root.join("lib/**/*.rb")].each {|f| require f}

  RSpec.configure do |config|
    config.mock_with :mocha
    config.mock_with :rspec
    # config.include Rails.application.routes.url_helpers
    # config.include UrlHelper
    config.use_transactional_fixtures = true

    # config.before(:suite) do
    #   DatabaseCleaner.strategy = :truncation
    # end

    # config.before(:each) do
    #   DatabaseCleaner.start
    # end

    # config.after(:each) do
    #   DatabaseCleaner.clean
    # end

  end

end

Spork.each_run do
  # Factory.factories.clear
  # Dir[Rails.root.join("spec/factories/**/*.rb")].each{ |f| load f }
  # Stootie::Application.reload_routes! # Spork.trap_method(Rails::Application, :reload_routes!)
  DatabaseCleaner.strategy = :truncation
  DatabaseCleaner.clean
  ActiveSupport::Dependencies.clear
end
