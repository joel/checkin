require 'spec_helper'

describe TokensController do
  render_views
  
  before(:each) do
    login_as_admin
  end
  
  describe "GET add_tokens" do
    it "..." do
      get :add_tokens, :user_id => @user
      response.should be_success
    end
  end
  
  describe "POST create_tokens" do
    it "..." do
      post :create_tokens, :user_id => @user, :number => "1", :price => "10", :token_type => { :token_type_id => "1" }
      response.should be_redirect
      assigns(:user).should_not be_nil
    end
  end
  
end
