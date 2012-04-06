namespace :thin do

  task :restart, :roles => :app do
    run "#{try_sudo} monit restart #{thin_service_name}"
  end

  task :start, :roles => :app do
    run "#{try_sudo} monit start #{thin_service_name}"
  end

  task :stop, :roles => :app do
    run "#{try_sudo} monit stop #{thin_service_name}"
  end
end