class Invitation < ActiveRecord::Base

  attr_accessible :followed_id, :follower_id
  
  belongs_to :followed, :class_name => "User"
  belongs_to :follower, :class_name => "User"
  
  validates :follower_id, :presence => true
  validates :followed_id, :presence => true
  
  def accept!
    self.follower.follow!(self.followed)
    self.destroy 
  end
  
  def denied!
    self.destroy 
  end
  
end
