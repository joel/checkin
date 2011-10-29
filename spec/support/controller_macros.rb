module ControllerMacros

  def self.included(base)
    base.extend(ClassMethods)
  end

  module ClassMethods
    def it_should_require_admin_for_actions(*actions)
      actions.each do |action|
        it "#{action} action should require admin" do
          get action, :id => 1
          response.should redirect_to(login_url)
          flash[:error].should == "Unauthorized Access"
        end
      end
    end
    def it_should_require_authenticated_person_for_actions(*actions)
      actions.each do |action|
        it "#{action} action should require authenticated user" do
          get action, :id => 1
          response.should redirect_to(login_url)
          flash[:error].should == "Unauthorized Access"
        end
      end
    end
  end

  def login_as_person_with_credits
    @user = Factory(:user)
    ['full day','half day', 'free'].each do |title|
      token_type = Factory(:token_type, :title => title)
      5.times { Factory(:token, :token_type_id => token_type.id, :user => @user, :start_at => nil, :stop_at => nil) }
    end
    visit "/users/sign_in"
    fill_in "user_email", :with => @user.email
    fill_in "user_password", :with => @user.password
    click_button "new_sessions_submit"
  end

  def login_as_admin
    @user = Factory(:user, :admin => true)
    sign_in :user, @user
  end

  def login_as_person
    @user = Factory(:user, :admin => false)
    sign_in :user, @user
  end

  def login_as_person_with_authentications
    @user = Factory(:user, :admin => false)
    FactoryGirl.create_list(:authentication, 5, :user => @user)
    sign_in :user, @user
  end

  def login_as_person_with_credits
    @user = Factory(:user)
    ['full day','half day', 'free'].each do |title|
      # token_type = FactoryGirl.build_stubbed(:token_type, :title => title)
      token_type = Factory(:token_type, :title => title)
      5.times { Factory(:token, :token_type_id => token_type.id, :user => @user, :start_at => nil, :stop_at => nil) }
    end
    sign_in :user, @user
  end

end