require 'spec_helper'

describe Invitation do

  describe "associations" do
    before { @invitation = Factory(:invitation) }
    it "have a follow methods" do
      [:followed, :follower, :accept!, :denied!].each do |method|
        @invitation.should respond_to(method)
      end
    end
  end
  
  describe "invitation : the followed" do
    before do
      @follower, @followed = Factory(:user), Factory(:user)
      @followed.invitation!(@follower)
      @invitation = @followed.invitations.first 
    end
    it "be able to accept an invitation" do
      @invitation.accept!
      @followed.invitations.size.should eql(0)
      @follower.following?(@followed).should be_true
    end
    it "be able to denied an invitation" do
      @invitation.denied!
      @followed.invitations.size.should eql(0)
      @followed.following?(@follower).should be_false
    end
  end
  
  describe "validations" do
    before do
      @follower, @followed = Factory(:user), Factory(:user)
      @invitation = Factory.build(:invitation, :follower_id => nil, :followed_id => nil)
    end
    it "require a follower_id" do
      @invitation.follower_id.should be_nil
      @invitation.valid?.should be_false
    end
    it "require a followed_id" do
      @invitation.followed_id.should be_nil
      @invitation.valid?.should be_false
    end
  end

end
