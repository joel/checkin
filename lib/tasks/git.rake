namespace :file do

  task :restore, :filename do |t, args|
    puts "bundle exec rake file:restore['filename']"
    puts "restore : #{args.filename}"
    # args.with_defaults(:filename => "foo")
    # Rake::Task[:environment].invoke
    puts "git checkout $(git rev-list -n 1 HEAD -- #{args.filename})^ -- #{args.filename}"
    sleep 3
    system "git checkout $(git rev-list -n 1 HEAD -- #{args.filename})^ -- #{args.filename}"
  end
  
end