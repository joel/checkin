['full day','half day', 'free'].each { |title| TokenType.create(:title=>title) }

['co-working','meeting', 'guest', 'other'].each do |title|
  puts "Add motivation #{title}" 
  Motivation.create(:title=>title)
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

tokens = ['Tricia','Ford']
tokens.each do |firstname|
  puts "Give some credit to #{firstname}"
  
  puts "Add five Full Day pass"
  h = { :cost => '4.8', :token_type_id => TokenType.find_by_title('full day').id, :used => false }
  5.times { User.find_by_firstname(firstname).tokens.create(h) }
  
  puts "Add five Half Day pass"
  h.merge!( :token_type_id => TokenType.find_by_title('half day').id, :used => false )
  5.times { User.find_by_firstname(firstname).tokens.create(h) }
end

User.all.each do |user|
  puts "Add picture for #{user.name}"
  user.avatar = File.new("public/images/#{user.email}.jpeg")
  user.save!
end

User.all.each do |user|
  puts "Add notification for #{user.name}"
  content = "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum."
  10.times { Notification.create(:user_id=>user.id,:content=>content) }
  sleep 1
end




