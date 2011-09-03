class CheckController < ApplicationController
  
  before_filter :authenticate_user!
  
  respond_to :html
  
  def new
    @user = User.find(params[:user_id])
    respond_with
    authorize! :manage, @user
  end

  def create
    @user = User.find(params[:user_id])
    authorize! :manage, @user
    begin
      msg = @user.checkin(params[:token_type_id], params[:motivation_id], current_user.id)
      flash[:success] = msg
    rescue Exception => e
      flash[:notice] = e.message
    end
    respond_with @user
  end

end
