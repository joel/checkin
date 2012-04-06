namespace :resque do
  task :restart, :roles => :app do
    run "#{try_sudo} monit restart #{resque_service_name}"
  end
  
  task :start, :roles => :app do
    run "#{try_sudo} monit start #{resque_service_name}"
  end
end