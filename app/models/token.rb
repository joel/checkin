class Token < ActiveRecord::Base
  
  belongs_to :user
  belongs_to :token_type
  belongs_to :motivation
  belongs_to :checkin_owner, :class_name => "User"
  belongs_to :token_owner, :class_name => "User"
  
  
  scope :available, where(:used => false|nil)
  scope :used, where(:used => true)
  
  validates_presence_of :cost

  def checkin(motivation_id, checkin_owner_id = nil)
    msg, options = "", {}
    if self.token_type.title == 'full day' or self.token_type.title == 'free'
      options.merge!(:start_at => self.start_time_of_day, :stop_at => self.stop_time_of_day)
      msg = I18n.t('models.token.full_day')
    else
      if Time.now < self.time_break
        options.merge!(:start_at => self.start_time_of_day, :stop_at => self.time_break)
        msg = I18n.t('models.token.morning_half_day')
      else
        options.merge!(:start_at => self.time_break, :stop_at => self.stop_time_of_day)
        msg = I18n.t('models.token.afternoon_half_day')
      end
    end
    options.merge!(:used => true, :motivation_id => motivation_id, :checkin_owner_id => checkin_owner_id)
    self.update_attributes(options)
    self.user.update_attribute(:process_done,false) # Add refresh for next time
    msg
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
