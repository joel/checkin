set :normal_symlinks, %w(
  config/database.yml
  config/settings.yml
  config/settings/production.yml
  public/uploads
)

namespace :symlinks do
  
  desc "Create the link to config/environments"
  task :default_config do
    commands = normal_symlinks.map do |path|
      "ln -nfs #{shared_path}/#{path} #{latest_release}/#{path}"
    end

    commands << "mkdir -p #{latest_release}/vendor"
    commands << "ln -nfs #{shared_path}/bundle #{latest_release}/vendor/bundle"
    commands << "ln -nfs #{shared_path}/doc #{latest_release}/doc"

    commands << "ln -nfs Gemfile.lock #{latest_release}/public"

    run "#{commands.join(' && ')}"
  end

  desc "Create shared folder to be linked"
  task :setup do
    sudo "mkdir -p #{shared_path}/config #{shared_path}/bundle #{shared_path}/doc #{shared_path}/uploads"
    sudo "chown -R capistrano:users #{deploy_to}"
  end
end

after 'deploy:setup', 'symlinks:setup'
before 'deploy:finalize_update', 'symlinks:default_config'