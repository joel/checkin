require 'spec_helper'

describe CheckController do
  render_views
  
  before(:each) do
    login_as_person_with_credits
  end
  
  describe "GET new" do
    it "assigns a new import as @import" do
      get :new, :user_id => @user.id
      assigns(:user).should eql(@user)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "create a new checkin" do
        token = @user.tokens.available.first
        token_type = token.token_type
        motivation = token.motivation
        post :create, :user_id => @user, :token_type_id => token_type, :motivation_id => motivation
        assigns(:user).checkin?.should be_true
        ActionMailer::Base.deliveries.should_not be_empty # TODO what wrong here ?!
      end
    end
  end
  
end
