require 'spec_helper'

describe User do

  describe "database constraintes" do
    before { @user = Factory(:user) }
    it "should be match" do
      @user.gender.should eql('Mr')
    end
  end
  
  describe "test show_button_folow?(other) method" do
    before(:each) do
      @follower, @followed = Factory(:user), Factory(:user)
    end
    it "no action has been made" do
      @follower.show_button_folow?(@followed).should be_true
    end
    it "make an request of invitation" do
      @followed.invitation!(@follower)
      @follower.show_button_folow?(@followed).should be_false
    end
    it "accpet invitation" do
      @followed.invitation!(@follower)
      @followed.invitations.first.accept!
      @follower.show_button_folow?(@followed).should be_false
      @followed.show_button_folow?(@follower).should be_false
    end
  end
  
  describe "test api key set" do
    before { @user = Factory(:user) }
    it "have an api key" do
      @user.authentication_token.should_not be_nil
    end
  end

  describe "test token availability" do
    before do 
      @user = Factory(:user)
      5.times { Factory(:token, :user => @user) }
    end
    it "all must be available!" do
      @user.tokens.count.should eql(5)
      @user.tokens.available.count.should eql(5)
    end
  end
  
  describe "test number of checkin" do
    before(:each) do
      @first_major, @second_major = Factory(:user), Factory(:user)
      full_day = Factory(:token_type,:title=>'full day')
      5.times do
        Factory(:token,:token_type=>full_day,:user=>@first_major,:start_at=>nil,:stop_at=>nil)
        Factory(:token,:token_type=>full_day,:user=>@second_major,:start_at=>nil,:stop_at=>nil)
      end
    end
    it "test increment counter" do
      for i in 1..2
        Timecop.freeze(Time.now.advance(:days => +i)) do
          token = @first_major.tokens.available.pop
          @first_major.checkin(token.token_type, token.motivation)
          @first_major.nb_of_checkin.should eql(i)
          # Set at first !
          # @first_major.nb_checkin_label.should eql("You have #{i} checkin, you are Major of this place")
          # @first_major.checkin_label_msg.should eql("You have #{i} checkin, you are Major of this place")
          # User.nb_of_checkin_label(@first_major).should eql("You have #{i} checkin, you are Major of this place")
        end
      end
      for i in 1..2
        Timecop.freeze(Time.now.advance(:days => +i)) do
          token = @second_major.tokens.available.pop
          @second_major.checkin(token.token_type, token.motivation)
          @second_major.nb_of_checkin.should eql(i)
          # Set at first !
          # @second_major.nb_checkin_label.should eql("You have #{i} checkin")
          # User.nb_of_checkin_label(@second_major).should eql("You have #{i} checkin")
        end
      end
      Timecop.freeze(Time.now.advance(:days => +3)) do
        token = @second_major.tokens.available.pop
        @second_major.checkin(token.token_type, token.motivation)
        @second_major.nb_of_checkin.should eql(3)
        # Set at first !
        # @second_major.nb_checkin_label.should eql("You have #{3} checkin, you are Major of this place")
        # User.nb_of_checkin_label(@second_major).should eql("You have #{3} checkin, you are Major of this place")
      end
    end
  end
    
  describe "test normalize name" do
    before(:each) do
      @firstname, @lastname = "jean-baptiste emanuel", "zorg"
      @user = Factory(:user, :firstname => @firstname, :lastname => @lastname)
    end
    it "firstname titlecase" do
      @user.firstname.should eql("Jean-Baptiste Emanuel")
    end
    it "lastname upcase" do
      @user.lastname.should eql("ZORG")
    end
  end

  describe "get status of checkin person" do

    before(:each) do
      @user = Factory(:user)
      @full_day, @half_day = Factory(:token_type,:title=>'full day'), Factory(:token_type,:title=>'half day')
      @motivation = Factory(:motivation)
      5.times { Factory(:token,:token_type=>@full_day,:motivation=>@motivation,:user=>@user,:start_at=>nil,:stop_at=>nil) }
      5.times { Factory(:token,:token_type=>@half_day,:motivation=>@motivation,:user=>@user,:start_at=>nil,:stop_at=>nil) }
      @user.reload
    end

    it "good checkin label for none checkin person" do
      Timecop.freeze(Time.now.change(:hour => 10)) do
        @user.checkin_label.should eql("Current not checkin...")
      end
    end

    it "good checkin label for full day token" do
      Timecop.freeze(Time.now.change(:hour => 10)) do
        token = @user.tokens.available.first(:conditions=>{:token_type_id=>@full_day.id})
        @user.checkin(token.token_type,token.motivation)
        @user.reload
        @user.checkin_label.should eql("(I'm here to #{@full_day.title} for #{token.motivation.title})")
      end
    end

    it "good checkin label for half day token" do
      Timecop.freeze(Time.now.change(:hour => 10)) do
        token = @user.tokens.available.first(:conditions=>{:token_type_id=>@half_day.id})
        @user.checkin(token.token_type,token.motivation)
        @user.reload
        @user.checkin_label.should eql("(I'm here to #{@half_day.title} for #{@motivation.title})")
      end
    end

  end
  
  describe "get token owner and checkin owner of checkin person" do
    before(:each) do
      @user, @free = Factory(:user), Factory(:token_type, :title=>'free')
      5.times { Factory(:token, :token_type => @free, :user => @user, :start_at => nil, :stop_at => nil,
          :checkin_owner => nil, :token_owner => nil) }
      @msg = "This credit was given by OWNER_TOKEN and This check-in was done by OWNER_CHECKIN"
    end
    
    it "good checkin label for none checkin person" do
      Timecop.freeze(Time.now.change(:hour => 10)) do
        @user.checkin_owners_label.should eql("Current not checkin...")
      end
    end

    it "token owner and checkin owner is Nobody" do
      Timecop.freeze(Time.now.advance(:days => +1)) do
        token = @user.tokens.available.first(:conditions=>{:token_type_id=>@free.id})
        @user.checkin(token.token_type, token.motivation)
        @msg.gsub!('OWNER_TOKEN',"Nobody")
        @msg.gsub!('OWNER_CHECKIN',"Nobody")
        @user.checkin_owners_label.should eql(@msg)
      end
    end

    it "token owner and checkin owner HimSelf" do
      Timecop.freeze(Time.now.advance(:days => +2)) do
        token = @user.tokens.available.first(:conditions=>{:token_type_id=>@free.id})
        @user.checkin(token.token_type, token.motivation, @user.id)
        @msg.gsub!('OWNER_TOKEN',"Nobody")
        @msg.gsub!('OWNER_CHECKIN',"HimSelf")
        @user.checkin_owners_label.should eql(@msg)
      end
    end

    it "Korben Dallas token owner and Ruby Rhod checkin owner" do
      Timecop.freeze(Time.now.advance(:days => +3)) do
        korben_dallas = Factory(:user, :firstname => 'Korben', :lastname => 'Dallas', :admin => true)
        ruby_rhod = Factory(:user, :firstname => 'Ruby', :lastname => 'Rhod', :admin => true)
        full_day = Factory(:token_type, :title => 'full day')
        Factory(:token, :token_type => full_day, :user => @user, :start_at => nil, :stop_at => nil, :checkin_owner => nil,
          :token_owner => korben_dallas) 
        token = @user.tokens.available.first(:conditions=>{:token_type_id => full_day.id})
        @user.checkin(token.token_type, token.motivation, ruby_rhod.id)
        @msg.gsub!('OWNER_TOKEN',"Korben DALLAS")
        @msg.gsub!('OWNER_CHECKIN',"Ruby RHOD")
        @user.checkin_owners_label.should eql(@msg)
      end
    end
  end

  describe "checkin with valide credits" do
    before do
      @user = Factory(:user)
      full_day = Factory(:token_type,:title => 'full day')
      10.times { Factory(:token, :token_type => full_day, :user => @user) }
      @user.reload
    end
    it "be work" do
      @user.tokens.available.size.should eql(10)
      token = @user.tokens.available.all.pop
      expect { 
        @user.checkin(token.token_type, token.motivation)
      }.to_not raise_error
      expect { 
        @person.checkin(rand(9999999), token.motivation) # TokenType unknow
      }.to raise_error
    end
  end

  describe "test remain_tokens method" do
    before do
      @user = Factory(:user)
      ['full day','half day', 'free'].each do |title|
        token_type = Factory(:token_type, :title=>title)
        5.times { Factory(:token, :token_type => token_type, :user => @user, :start_at => nil, :stop_at => nil) }
      end
    end
    it "must be provide the good number of avalaible tokens by token_type" do
      @user.reload
      ['full day','half day', 'free'].each do |title|
        token_type_id = TokenType.find_by_title(title)
        @user.remain_tokens(token_type_id).should eql(5)
      end
    end
  end
  
  describe "invitation associations" do
    before { @user = Factory(:user) }
    it "have a invitations method" do
      [:invitations, :invitation!, :invitation?].each do |method|
        @user.should respond_to(method)
      end
    end
  end
  
  describe "invitation : the follower" do
    before do
      @follower,@followed = Factory(:user), Factory(:user)
    end
    it "be capable of ask an invitation" do
      @followed.invitation!(@follower)
      @followed.invitations.find_by_follower_id(@follower.id).should be_true
    end
    it "be able to know if he has requested an invitation" do
      @follower.invitation!(@followed)
      @follower.invitation?(@followed).should be_true
    end
  end
  describe "invitation : the followed" do
    before do
      @follower, @followed = Factory(:user), Factory(:user)
      @followed.invitation!(@follower)
    end
    it "have some invitations" do
      @followed.invitations.size.should eql(1)
    end
  end

  describe "relationships" do
    before do
      @user, @followed = Factory(:user), Factory(:user)
    end
    it "have a relationships method" do
      [:relationships, :following?, :follow!,:reverse_relationships, :followers].each do |method|
        @user.should respond_to(method)
      end
    end
    it "follow another user" do
      @user.follow!(@followed)
      @user.following.include?(@followed).should be_true
    end
    it "unfollow another user" do
      @user.follow!(@followed)
      @user.unfollow!(@followed)
      @user.following.include?(@followed).should be_false
    end
    it "include the follower in the followers array" do
      @user.follow!(@followed)
      @followed.followers.include?(@user).should be_true
    end
  end

  describe "get status of uncheckin person" do
    before do
      @user = Factory(:user)
      full_day = Factory(:token_type, :title => 'full day')
      10.times { Factory(:token,:token_type => full_day, :user => @user) }
      @user.reload
    end
    it "be not checkin status" do
      @user.tokens.available.size.should eql(10)
      Timecop.freeze(Time.now.change(:hour => 10)) do
        @user.checkin?.should be_false, "Checkin? Must be return false"
      end
    end
  end

  describe "get status of checkin person" do
    before do
      @user = Factory(:user)
      full_day = Factory(:token_type, :title => 'full day')
      10.times { Factory(:token,:token_type => full_day, :user => @user, :start_at => nil, :stop_at => nil) }
      @user.reload
    end
    it "be good checkin status" do
      @user.tokens.available.size.should eql(10)
      token = @user.tokens.available.all.pop
      Timecop.freeze(Time.now.change(:hour => 10)) do
        @user.checkin(token.token_type,token.motivation)
        @user.reload
        @user.checkin?.should be_true, "Checkin? Must be return true"
      end
    end
  end
  
  describe "attemps to checkin for person has already checkin" do
    before do
      @user = Factory(:user)
      full_day = Factory(:token_type, :title => 'full day')
      10.times { Factory(:token,:token_type => full_day, :user => @user, :start_at => nil, :stop_at => nil) }
      @user.reload
    end
    it "be throw an exception" do
      @user.tokens.available.size.should eql(10)
      Timecop.freeze(Time.now.change(:hour => 10)) do
        # First checkin !
        token = @user.tokens.available.all.pop
        @user.checkin(token.token_type, token.motivation)
        @user.reload
        @user.checkin?.should be_true, "Checkin? Must be return true"
        # Try to checkin one more again
        expect { 
          begin
             @user.checkin(token.token_type, token.motivation)
           rescue Exception => e
             raise e
           end
        }.to raise_error
      end
    end
  end
  
end