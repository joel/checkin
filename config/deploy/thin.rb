namespace :thin do

  task :restart, :roles => :app do
    run "#{try_sudo} monit restart thin_#{application}-0"
  end

  task :start, :roles => :app do
    run "#{try_sudo} monit start thin_#{application}-0"
  end

  task :stop, :roles => :app do
    run "#{try_sudo} monit stop thin_#{application}-0"
  end
end