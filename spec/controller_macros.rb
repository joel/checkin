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
  
  def login_as_admin
    @user = Factory(:user)
    @person = Factory(:person,:user=>@user,:admin=>true)
    sign_in :user, @user
  end
  
  def login_as_person
    @user = Factory(:user)
    @person = Factory(:person,:user=>@user)
    sign_in :user, @user
  end
  
  def login_as_person_with_credits
    @user = Factory(:user)
    @person = Factory(:person,:user=>@user)
    ['full day','half day', 'free'].each do |title|
      token_type = Factory(:token_type,:title=>title)
      5.times { Factory(:token,:token_type=>token_type,:person=>@person,:start_at=>nil,:stop_at=>nil) }
    end
    sign_in :user, @user
  end
  
end