require 'spec_helper'

describe AuthenticationsController do
  render_views

  before(:each) do
    login_as_person_with_authentications
  end
    
  describe "GET index" do
    it "assigns @authentications" do
      get :index
      assigns(:authentications).should be_present
    end
  end

  # describe "POST create" do
  #   describe "with valid params" do
  #     it "create a new checkin" do
  #       provider = @user.authentications.first.provider
  #       uid = @user.authentications.first.uid
  #       # @controller.request.stub!(:env).with('omniauth.auth').and_return({:provider => provider, :uid => uid})
  #       @controller.request.stub!(:env).and_return({'omniauth.auth': {'provider': provider, 'uid': uid}})
  #       # @controller.request.expects(:subdomains).returns(['www'])
  #       # 
  #       # request.env["omniauth.auth"]
  #       
  # 
  #       post :create
  #       response.should redirect_to(users_url(@user))
  #     end
  #   end
  # end
  
  describe "DELETE destroy" do
    it "destroys the requested message" do
      expect {
        delete :destroy, :id => @user.authentications.first.id.to_s
      }.to change(Authentication, :count).by(-1)
    end
    # it "redirects to the messages list" do
    #   @message = FactoryGirl.create(:message, :stoot_id => @stoot.id)
    #   delete :destroy, :stoot_id => @stoot.id.to_s, :id => @message.id.to_s
    #   response.should redirect_to(stoot_messages_url(@stoot))
    # end
  end
  
end
