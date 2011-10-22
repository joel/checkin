# A sample Guardfile
# More info at https://github.com/guard/guard#readme

guard 'bundler' do
  watch('Gemfile')
end

guard 'spork', :cucumber_env => { 'RAILS_ENV' => 'test' },
  :rspec_env => { 'RAILS_ENV' => 'test' },
  :wait => 40, # Seconds to wait for the server to starts, default: 20
  :cucumber => false,
  :rspec => true,
  :test_unit => false,
  :bundler => true,
  :rspec_port => 8989,
  :cucumber_port => 8990 do
  watch('config/application.rb')
  watch('config/environment.rb')
  watch(%r{^config/environments/.+\.rb$})
  watch(%r{^config/initializers/.+\.rb$})
  watch('spec/spec_helper.rb')
  # watch('config/settings.yml')
  # watch(%r{^config/settings/(.+)\.yml$})
  watch(%r{^config/locales/(.+)\.yml$})
  # watch(%r{^spec/factories/(.+)\.rb$})
  watch(%r{^lib/.+\.rb$})
  watch(%r{^spec/support/.+\.rb$})
end

guard 'rspec', :version => 2,
  :cli => "--color --format nested --fail-fast --drb -f progress --debug",         # pass arbitrary RSpec CLI arguments, default: "-f progress"
  :bundler => true,           # don't use "bundle exec" to run the RSpec command, default: true
  :rvm => '1.9.2-p290',       # directly run your specs on multiple Rubies, default: nil
  :notification => true,      # don't display Growl (or Libnotify) notification after the specs are done running, default: true
  :all_after_pass => false,    # don't run all specs after changed specs pass, default: true
  :all_on_start => true,      # don't run all the specs at startup, default: true
  :keep_failed => false do
  # watch('config/settings.yml')
  # watch(%r{^config/settings/(.+)\.yml$})
  watch(%r{^spec/factories/(.+)\.rb$})
  watch(%r{^spec/.+_spec\.rb$})
  watch(%r{^app/(.+)\.rb$})                           { |m| "spec/#{m[1]}_spec.rb" }
  watch(%r{^lib/(.+)\.rb$})                           { "spec" }
  watch(%r{^app/controllers/(.+)_(controller)\.rb$})  { |m| ["spec/routing/#{m[1]}_routing_spec.rb", "spec/#{m[2]}s/#{m[1]}_#{m[2]}_spec.rb", "spec/acceptance/#{m[1]}_spec.rb"] }
  watch(%r{^spec/support/(.+)\.rb$})                  { "spec" }
  watch('spec/spec_helper.rb')                        { "spec" }
  watch('config/routes.rb')                           { "spec/routing" }
  watch('app/controllers/application_controller.rb')  { "spec/controllers" }
  watch(%r{^app/views/(.+)/.*\.(erb|haml)$})          { |m| "spec/requests/#{m[1]}_spec.rb" }
end

guard 'cucumber', :cli => '--no-profile --color --format progress --strict' do
  watch(%r{^features/.+\.feature$})
  watch(%r{^features/support/.+$})          { 'features' }
  watch(%r{^features/step_definitions/(.+)_steps\.rb$}) { |m| Dir[File.join("**/#{m[1]}.feature")][0] || 'features' }
end
