xml.instruct!
xml.people("type"=>"array") do
  @users.each do |p|
    xml.person do 
      xml.id("type"=>"integer") do
        p.id
      end
      xml.firstname p.firstname
      xml.lastname p.lastname
      xml.gender p.gender
    end
  end
end