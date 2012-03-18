namespace :resque do
  task :restart, :roles => :app do
    sudo "monit restart resque_#{application}"
  end
  
  task :start, :roles => :app do
    sudo "monit start resque_#{application}"
  end
end

after 'deploy:symlink', 'resque:restart'