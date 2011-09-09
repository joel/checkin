require 'spec_helper'

describe Relationship do
  
  describe "relationships" do
    before do
      @follower, @followed = Factory(:user), Factory(:user)
      @relationship = @follower.relationships.build(:followed_id => @followed.id)
    end
    it "should create a new instance given valid attributes" do
      expect { @relationship.save! }.to_not raise_error
    end
  end

  describe "validations" do
    before do
      @follower, @followed = Factory(:user), Factory(:user)
      @relationship = @follower.relationships.build(:followed_id => @followed.id)
    end
    it "require a follower_id" do
      @relationship.follower_id = nil
      @relationship.should_not be_valid
    end
    it "require a followed_id" do
      @relationship.followed_id = nil
      @relationship.should_not be_valid
    end
  end

  describe "follow methods" do
    before do
      @follower, @followed = Factory(:user), Factory(:user)
      @relationship = @follower.relationships.build(:followed_id => @followed.id)
      @relationship.save!
    end
    it "have a follow methods" do
      [:follower, :followed].each do |method|
        @relationship.should respond_to(method)
      end
    end
    it "have the right follower" do
      @relationship.follower.should eq(@follower)
    end
    it "have the right followed user" do
      @relationship.followed.should eq(@followed)
    end
  end

end
