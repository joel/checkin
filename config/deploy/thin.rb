namespace :thin do

  task :restart, :roles => :app do
    sudo "monit restart thin_#{application}-0"
  end

  task :start, :roles => :app do
    sudo "monit start thin_#{application}-0"
  end

  task :stop, :roles => :app do
    sudo "monit stop thin_#{application}-0"
  end
end
