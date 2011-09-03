namespace :data do
  task :checkin do
    Rake::Task[:environment].invoke
    Token.used.order(:updated_at).all.each do |token|
      puts "#{token.person.name} #{token.person.user.email} checkin at #{token.start_at.strftime("%d %B %Y %H:%M:%S")} to #{token.stop_at.strftime("%d %B %Y %H:%M:%S")} for #{token.motivation.title} to #{token.token_type.title} action at #{token.updated_at.strftime("%d %B %Y %H:%M:%S")}"
    end
    # Token.used.all.each do |token|
    #   puts "#{token.person.name};#{token.person.user.email};#{token.start_at.strftime("%d %B %Y %H:%M:%S")};#{token.stop_at.strftime("%d %B %Y %H:%M:%S")};#{token.motivation.title};#{token.token_type.title};#{token.updated_at.strftime("%d %B %Y %H:%M:%S")}"
    # end
  end
end
