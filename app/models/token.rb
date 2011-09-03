class Token < ActiveRecord::Base
  
  belongs_to :user
  belongs_to :token_type
  belongs_to :motivation
  belongs_to :checkin_owner, :class_name => "User"
  belongs_to :token_owner, :class_name => "User"
  
  
  scope :available, where(:used => false)
  scope :used, where(:used => true)
  
  validates_presence_of :cost
  
  def checkin(motivation_id, checkin_owner_id = nil)
    msg = ""
    if self.token_type.title == 'full day' or self.token_type.title == 'free'
      self.update_attributes(:start_at=>self.start_time_of_day,:stop_at=>self.stop_time_of_day,:used=>true,:motivation_id=>motivation_id, :checkin_owner_id => checkin_owner_id)
      msg = "Your day's credit has well been taken"
    else
      if Time.now < self.time_break
        self.update_attributes(:start_at=>self.start_time_of_day,:stop_at=>self.time_break,:used=>true,:motivation_id=>motivation_id, :checkin_owner_id => checkin_owner_id)
        msg = "Your morning credit has well been taken"
      else
        self.update_attributes(:start_at=>self.time_break,:stop_at=>self.stop_time_of_day,:used=>true,:motivation_id=>motivation_id, :checkin_owner_id => checkin_owner_id)
        msg = "Your afternoon credit has well been taken"
      end
   end   
  end
  
  def start_time_of_day
    Time.now.beginning_of_day  
  end
  
  def stop_time_of_day
    Time.now.end_of_day
  end
  
  def time_break
    Time.now.change(:hour => 13)
  end
  
end
