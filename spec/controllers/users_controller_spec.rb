require 'spec_helper'

describe UsersController do
  render_views
  
  describe "as an authenticated person" do
    before { login_as_person }
    it "index action should render index template" do
      get :index
      response.should render_template(:index)
    end
    it "show action should render show template" do
      3.times { Factory(:user) }
      get :show, :id => User.first
      response.should render_template(:show)
    end
  end
  
  describe "as an inviation" do
    before { login_as_person }
    it "must be denied" do
      @follower = Factory(:user)
      invitation = Invitation.create(:follower_id => @follower.id, :followed_id => @user.id)
      delete :denied_invitation, :id => invitation.id
      assigns(:invitation).should_not nil
      assigns(:user).should_not nil
      flash.should_not be_empty
      flash[:notice].should == "Ok bye bye #{@follower.name} !"
    end
  end
  
end