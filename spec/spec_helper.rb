require 'rubygems'
require 'spork'

Spork.prefork do

  # if ENV['CODE_COVERAGE'] == '1'
  #   require 'simplecov'
  #   SimpleCov.start 'rails'
  # end
  # require 'cover_me' # Ruby 1.9

  ENV["RAILS_ENV"] ||= 'test'

  # https://github.com/timcharper/spork/wiki/Spork.trap_method-Jujutsu
  require 'rails/application'
  Spork.trap_method(Rails::Application, :reload_routes!)

  # require "rails/mongoid"
  # Spork.trap_class_method(Rails::Mongoid, :load_models)

  require File.expand_path("../../config/environment", __FILE__)

  require 'rspec/rails'
  require 'factory_girl'
  # https://github.com/irohiroki/guard-spork-ruby-debug-sample
  # require 'spork/ext/ruby-debug'
  require 'database_cleaner'

  Dir[Rails.root.join("spec/support/**/*.rb")].each {|f| require f}
  Dir[Rails.root.join("lib/**/*.rb")].each {|f| require f}

  RSpec.configure do |config|
    config.mock_with :mocha
    config.mock_with :rspec

    # config.include(Devise::TestHelpers)
    # config.include Devise::TestHelpers, :type => :acceptance
    config.include Devise::TestHelpers, :type => :controller
    config.include Devise::TestHelpers, :type => :view
    config.include Devise::TestHelpers, :type => :helper
    # config.include(ControllerMacros)
    # config.include ControllerMacros, :type => :acceptance
    config.include ControllerMacros, :type => :controller
    config.include ControllerMacros, :type => :view
    config.include ControllerMacros, :type => :helper
    
    config.use_transactional_fixtures = false
    config.treat_symbols_as_metadata_keys_with_true_values = true
    config.filter_run :focus => true
    config.run_all_when_everything_filtered = true

    config.include Capybara::DSL, :type => :acceptance
    config.include ActionController::RecordIdentifier, :type => :acceptance

    config.include AcceptanceHelpers, :type => :acceptance
    
    # config.include HelperMethods, :type => :acceptance

    config.before(:all) do
      # reset_email
      DeferredGarbageCollection.start
    end

    config.after(:all) do
      Capybara.reset_sessions!
      DeferredGarbageCollection.reconsider
    end

  end

end

Spork.each_run do
  FactoryGirl.reload
  # I18n
  I18n.backend.reload!
  # Fabrication.clear_definitions
end
