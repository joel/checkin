namespace :resque do
  task :restart, :roles => :app do
    run "#{try_sudo} monit restart resque_#{application}"
  end
  
  task :start, :roles => :app do
    run "#{try_sudo} monit start resque_#{application}"
  end
end