module CheckinLabel
  # extend ActiveSupport::Concern

  module ClassMethods
    
    def nb_of_checkin_label(user_id)
      begin
        Resque.enqueue(AsyncCheckinLabel, user_id)
      rescue Errno::ECONNREFUSED => e
        logger.error e.message
        AsyncCheckinLabel.perform(user_id)
      end
    end
    
  end
  
  # module InstanceMethods
  # end    
  
  def self.included(base)
    # base.send :include, InstanceMethods
    base.send :extend, ClassMethods
  end
  
  # def self.included(base)
  #   base.class_eval do
  # 
  #     def nb_of_checkin_label(user_id)
  #       begin
  #         Resque.enqueue(AsyncCheckinLabel, user_id)
  #       rescue Errno::ECONNREFUSED => e
  #         logger.error e.message
  #         AsyncCheckinLabel.perform(user_id)
  #       end
  #     end
  #           
  #   end
  # end
  
  class LoggedJob
    
    def self.before_perform_log_job(*args)
      Rails.logger.info "About to before perform #{self} with #{args.inspect} User#id:#{args[0]}"
    end
    
    def self.after_perform_log_job(*args)
      Rails.logger.info "About to after perform #{self} with #{args.inspect} User#id:#{args[0]}"
    end
    
  end
  
  class AsyncCheckinLabel < LoggedJob
    @queue = :checkin_count
    def self.perform(user_id)
      user = User.where(:id => user_id.to_i).first
      msg = I18n.t('users.nb_checkin', :nb => user.nb_of_checkin)
      msg << ", " + I18n.t('users.major') if user.major?
      user.update_attributes(:checkin_label_msg => msg.html_safe, :process_done => true)
    end
  end

end

# class ActiveRecord::Base
#   include CheckinLabel
# end
