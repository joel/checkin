namespace :cache do
  task :clear, :roles => :app do
    run "cd #{current_release} && rm -rf tmp/cache/[^.]* && echo 'flush_all' | nc -q 1 localhost 11211"
  end
end

after 'deploy:symlink', 'cache:clear'
