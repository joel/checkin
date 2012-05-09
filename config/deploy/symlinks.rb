set :files, %w(
  config/database.yml
  config/settings.yml
)
  
set :normal_symlinks, %w(
  config/database.yml
  config/settings.yml
  public/uploads
)

set :directories, %w(
  config
  bundle
  doc
  public/uploads
  assets
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

    commands << "cp -f Gemfile.lock #{latest_release}/public"

    run "#{commands.join(' && ')}"
  end

  desc "Create shared folder to be linked"
  task :setup do
    commands = directories.map do |dir|
      "#{shared_path}/#{dir}"
    end
    sudo "mkdir -p #{commands.join(' ')}"
    files.each do |file_name|
      sudo "touch #{shared_path}/#{file_name}"
    end
    sudo "chown -R capistrano:users #{deploy_to}"
  end
end

after 'deploy:setup', 'symlinks:setup'
before 'deploy:finalize_update', 'symlinks:default_config'