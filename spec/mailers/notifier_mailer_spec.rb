require "spec_helper"

describe NotifierMailer do
  
  describe "send notification for user whos checkin" do
    before do
      @user = Factory(:user)
      free = Factory(:token_type, :title => 'free')
      1.times { Factory(:token,:token_type=>free,:user=>@user,:start_at=>nil,:stop_at=>nil,:checkin_owner=>nil,:token_owner=>nil) }
    end
    it "notification delivered" do
      token = @user.tokens.available.pop
      mail = NotifierMailer.checkin_notification(@user.id, token.token_type.title, token.motivation.title).deliver
      mail.subject.should eql("I'm at #{Settings.app.name} to #{token.token_type.title} for #{token.motivation.title}") 
      mail.to.should eql([@user.email]) 
      mail.from.should eql([Settings.app.mail.user_name]) 
      mail.body.encoded.should include("Thank you for check-in!")
    end
  end
  
  describe "send notifications to followers" do
    before do
      @user = Factory(:user)
      free = Factory(:token_type,:title=>'free')
      # Add Credits
      1.times { Factory(:token,:token_type=>free,:user=>@user,:start_at=>nil,:stop_at=>nil,:checkin_owner=>nil,:token_owner=>nil) }
      # Add Followers
      5.times { Factory(:user).follow!(@user) }
    end
    it "followers notifications delivered" do
      token = @user.tokens.available.pop
      @user.followers.all.each do |follower|
        mail = NotifierMailer.notify_followers(follower.id, @user.id, token.token_type.title, token.motivation.title).deliver
        mail.subject.should eql("#{@user.name} is at #{Settings.app.name} to #{token.token_type.title} for #{token.motivation.title}") 
        mail.to.should eql([follower.email]) 
        mail.from.should eql([Settings.app.mail.user_name]) 
        mail.body.encoded.should include("You follow #{@user.firstname}.")
        mail.body.encoded.should include("#{follower.firstname},")
      end
    end
  end
  
  describe "send notifications to people from admin" do
    before do
      @sender = Factory(:user,:admin=>true)
      10.times { Factory(:user) }
      @notification = Factory(:notification)
    end
    it "people notifications delivered" do
      @notification.at_who.each do |user_attributes|
        user = User.find_by_id(user_attributes['id'].to_i)
        mail = NotifierMailer.notify_people(@sender.id, @notification.id, user.id).deliver
        mail.subject.should eql("#{@sender.firstname} warn you about #{Settings.app.name}") 
        # Person.members.collect { |p| Array(p.email) }.flatten!.should include(mail.to) # Should be WORK !!!!
        mail.to.should eql([user.email]) 
        mail.from.should eql([Settings.app.mail.user_name]) 
        mail.body.encoded.should include("#{user.firstname},")
        mail.body.encoded.should include(@notification.content)
      end
    end
  end
  
end
