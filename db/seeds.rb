['full day','half day', 'free'].each { |title| TokenType.create(:title=>title) unless TokenType.where(:title=>title).exists? }

['co-working','meeting', 'guest', 'other'].each do |title|
  puts "Add motivation #{title}" 
  Motivation.create(:title=>title) unless Motivation.where(:title=>title).exists?
end

people = [{:gender=>'Mr',:firstname=>'Zaphod',:lastname=>'Beeblebrox',:company=>'Galaxy',:phone=>'0102030405',:email=>'zaphod@checkin.com'},
{:gender=>'Mr',:firstname=>'Ford',:lastname=>'Prefect',:company=>'Galaxy',:phone=>'0102030405',:email=>'ford@checkin.com'},
{:gender=>'Mr',:firstname=>'Arthur',:lastname=>'Dent',:company=>'None',:phone=>'0102030405',:email=>'arthur@checkin.com'},
{:gender=>'Mlle',:firstname=>'Tricia',:lastname=>'McMillan',:company=>'None',:phone=>'0102030405',:email=>'tricia@checkin.com'},
{:gender=>'Mr',:firstname=>'Robert',:lastname=>'Paulson',:company=>'Fight Club',:phone=>'0102030405',:email=>'robert@checkin.com'},
{:gender=>'Mlle',:firstname=>'Marla',:lastname=>'Singer',:company=>'None',:phone=>'0102030405',:email=>'marla-singer@checkin.com'},
{:gender=>'Mr',:firstname=>'Jean-Baptiste Emanuel',:lastname=>'ZORG',:company=>'ZORG Corp',:phone=>'0102030405',:email=>'jbe@checkin.com'}]

index = 0
people.each do |h|
  puts "Create #{h[:firstname]} #{h[:lastname]} person"
  h.merge!(:password=>'123456', :password_confirmation=>'123456')
  User.create(h)
  index = index+1
end

admins = ['Zaphod','Jean-Baptiste Emanuel']
admins.each do |firstname|
  puts "Make #{firstname} admin"
  User.first(:conditions=>{:firstname=>firstname}).update_attribute(:admin,true)
end

tokens = ['Tricia','Ford','Arthur']
tokens.each do |firstname|
  puts "Give some credit to #{firstname}"
  
  puts "Add five Full Day pass"
  h = { :cost => '4.8', :token_type_id => TokenType.find_by_title('full day').id, :used => false }
  5.times { User.find_by_firstname(firstname).tokens.create(h) }
  
  puts "Add five Half Day pass"
  h.merge!( :token_type_id => TokenType.find_by_title('half day').id, :used => false )
  5.times { User.find_by_firstname(firstname).tokens.create(h) }
end

[['Zaphod','Tricia'],['Ford','Ford'],['Zaphod','Arthur']].each do |owner_name, person_name|
  person, owner, token_type_id = User.where(:firstname => person_name).first, User.where(:firstname => owner_name).first, TokenType.find_by_title('full day').id
  motivation_id = Motivation.first.id
  puts "#{owner_name} make checkin for #{person_name}"
  person.checkin(token_type_id, motivation_id, owner.id)
end

User.all.each do |user|
  puts "Add picture for #{user.name}"
  user.avatar = File.new("public/images/#{user.email}.jpeg")
  user.save!
end

puts "Sends invitations !"
[ ['Zaphod',['Ford','Arthur','Tricia','Robert','Marla','Jean-Baptiste Emanuel']],
  ['Ford',['Zaphod','Arthur','Tricia','Robert','Marla','Jean-Baptiste Emanuel']]].each do |person_name, guests|
  person = User.where(:firstname => person_name).first
  guests.each do |guest_name|
    guest = User.where(:firstname => guest_name).first
    puts "#{person_name} invite #{guest_name}"
    person.invitation!(guest)
  end
end

puts "Accept invitations !"
['Ford','Arthur'].each do |person_name|
  person = User.where(:firstname => person_name).first
  person.invitations.all.each do |invitation|
    puts "#{person_name} accept invitation of #{invitation.follower.name}"
    invitation.accept!
  end
end



User.all.each do |user|
  puts "Add notification for #{user.name}"
  content = "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum."
  10.times { Notification.create(:user_id=>user.id,:content=>content) }
  sleep 1
end




