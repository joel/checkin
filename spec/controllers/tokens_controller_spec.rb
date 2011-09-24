require 'spec_helper'

describe TokensController do
  render_views
  
  before(:each) do
    login_as_admin
  end
  
  describe "GET add_tokens" do
    it "..." do
      user = Factory(:user, :admin => false)
      user.tokens.count.should eql(0)
      get :add_tokens, :user_id => user.id.to_s
      response.should be_success
      assigns(:user).should_not be_nil
    end
  end
  
  describe "POST create_tokens" do
    before do
      ['full day','half day', 'free'].each do |title|
        Factory(:token_type, :title => title)
      end
    end
    it "..." do
      user = Factory(:user, :admin => false)
      user.tokens.count.should eql(0)
      post :create_tokens, :user_id => user.id.to_s, :number => "1", :price => "10", :token_type => { :token_type_id => TokenType.first.id.to_s }
      response.should be_redirect
      assigns(:user).should_not be_nil
      user.tokens.count.should eql(1)
      user.tokens.first.token_owner_id.should eql(@user.id)
    end
  end
  
end
