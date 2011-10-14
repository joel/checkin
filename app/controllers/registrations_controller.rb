class RegistrationsController < Devise::RegistrationsController
  
  def create
    super
    # user = User.new(params[:user])
    # if user.save
    #   if user.active_for_authentication?
    #     set_flash_message :notice, :signed_up if is_navigational_format?
    #     sign_in(:user, user)
    #     respond_with user, :location => after_sign_up_path_for(user)
    #   else
    #     set_flash_message :notice, :inactive_signed_up, :reason => inactive_reason(user) if is_navigational_format?
    #     expire_session_data_after_sign_in!
    #     respond_with user, :location => after_inactive_sign_up_path_for(user)
    #   end
    # else
    #   clean_up_passwords(user)
    #   respond_with_navigational(user) { render_with_scope :new }
    # end
    # build_resource
    # if resource.save
    #   if resource.active_for_authentication?
    #     set_flash_message :notice, :signed_up if is_navigational_format?
    #     sign_in(resource_name, resource)
    #     respond_with resource, :location => after_sign_up_path_for(resource)
    #   else
    #     set_flash_message :notice, :inactive_signed_up, :reason => inactive_reason(resource) if is_navigational_format?
    #     expire_session_data_after_sign_in!
    #     respond_with resource, :location => after_inactive_sign_up_path_for(resource)
    #   end
    # else
    #   clean_up_passwords(resource)
    #   respond_with_navigational(resource) { render_with_scope :new }
    # end
    session[:omniauth] = nil unless @user.new_record?
  end
  
  private
  
  def build_resource(*args)
    super
    if session[:omniauth]
      @user.apply_omniauth(session[:omniauth])
      @user.valid?
    end
  end
  
end
