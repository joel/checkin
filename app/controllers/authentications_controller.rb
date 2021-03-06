class AuthenticationsController < ApplicationController

  protect_from_forgery :except => [:create, :failure]

  def index
    @authentications = current_user.authentications if current_user
  end
  
  def create
    # render :text => request.env["omniauth.auth"]
    omniauth = request.env["omniauth.auth"]
    authentication = Authentication.find_by_provider_and_uid(omniauth['provider'], omniauth['uid'].to_s)
    if authentication
      flash[:notice] = "Signed in successfully."
      # sign_in_and_redirect(:user, authentication.user)
      sign_in(:user, authentication.user)
      redirect_to user_path(authentication.user)
    elsif current_user
      current_user.authentications.create!(:provider => omniauth['provider'], :uid => omniauth['uid'].to_s)
      flash[:notice] = "Authentication successful."
      redirect_to authentications_url
    else
      user = User.user_already_exist?(omniauth)
      unless user.new_record?
        user.authentications.create!(:provider => omniauth['provider'], :uid => omniauth['uid'].to_s)
        flash[:notice] = "Authentication successful."
        sign_in(:user, user)
        redirect_to authentications_url
      else
        # user = User.new
        user.apply_omniauth(omniauth)
        if user.save
          flash[:notice] = "Signed in successfully."
          sign_in_and_redirect(:user, user)
        else
          session[:omniauth] = omniauth.except('extra')
          redirect_to new_user_registration_url
        end
      end
    end
  end
  
  def destroy
    @authentication = current_user.authentications.find(params[:id])
    @authentication.destroy
    flash[:notice] = "Successfully destroyed authentication."
    redirect_to authentications_url
  end
  
  def failure
    flash[:error] = params[:message]
    render :action => :index
  end

end
