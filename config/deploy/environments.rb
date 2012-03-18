set :location, "ec2-107-21-172-87.compute-1.amazonaws.com"
# set :location, "107.21.172.87"

desc "Set the servers for production environment"
task :production do
  role :web, location                          # Your HTTP server, Apache/etc
  role :app, location                          # This may be the same as your `Web` server
  role :db,  location, :primary => true        # This is where Rails migrations will run
  #role :db, "your slave db-server here"

  set :deploy_to, "/var/www/#{application}"
  set :rails_env, 'production'
end