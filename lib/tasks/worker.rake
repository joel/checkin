require 'rails_config'
require 'resque/tasks'
task "resque:setup" => :environment
namespace :resque do
  task :setup do
    Resque.redis = "#{Settings.redis.host}:#{Settings.redis.port}"
    Resque.redis.namespace = Settings.redis.namespace
  end
end
