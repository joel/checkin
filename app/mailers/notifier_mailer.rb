class NotifierMailer < ActionMailer::Base
  include Resque::Mailer
  
  default :from => Settings.app.mail.user_name
  
  def checkin_notification(user_id, token_type, motivation)
    @user = User.find_by_id(user_id.to_i)
    mail(:to=>"#{@user.name} <#{@user.email}>", :subject=>"I'm at #{Settings.app.name} to #{token_type} for #{motivation}")
  end
  
  def notify_followers(follower_id, user_id, token_type, motivation)
    @follower = User.find_by_id(follower_id.to_i)
    @user = User.find_by_id(user_id.to_i)
    mail(:to=>"#{@follower.name} <#{@follower.email}>", :subject=>"#{@user.name} is at #{Settings.app.name} to #{token_type} for #{motivation}")
  end
  
  def notify_people(sender_id, notification_id, member_id)
    @sender = User.find_by_id(sender_id.to_i)
    @notification = Notification.find_by_id(notification_id.to_i)
    @member = User.find_by_id(member_id.to_i)
    mail(:to=>"#{@member.name} <#{@member.email}>",:subject=>"#{@sender.firstname} warn you about #{Settings.app.name}")
  end
  
  def self.safe_sending
    begin
      yield.deliver if Rails.env != 'development'
    rescue Exception => e
      logger.error e.message
      yield.deliver! if Rails.env != 'development'
    end
  end

end
