class Notification < ActiveRecord::Base
  
  paginates_per 15
  
  belongs_to :user
  
  before_create :serialize_to
  after_create :send_email
  
  serialize :at_who, Array
  
  private 
  
  def send_email
    self.update_attribute(:sent_at, Time.now)
    User.members.all.each do |member|
      NotifierMailer.safe_sending { NotifierMailer.notify_people(self.user.id, self.id, member.id) }
    end
  end
  
  def serialize_to
    a = []; User.members.all.each { |member| a << member.attributes }
    self.at_who = a
  end
  
  
end
