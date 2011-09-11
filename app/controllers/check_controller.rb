class CheckController < ApplicationController
  
  before_filter :authenticate_user!
  
  respond_to :html
  
  def new
    @user = User.find(params[:user_id])
    respond_with
    flash[:error] = "Ooooh no ^^ You have no enough credits... please, buy some credits !" unless @user.tokens.available.count > 0
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
