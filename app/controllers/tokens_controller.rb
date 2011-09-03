class TokensController < ApplicationController

  respond_to :html
  before_filter :authenticate_user!
  
  def add_tokens
    @user = User.find(params[:user_id])
    authorize! :manage, :all
    respond_with(@user)
  end
    
  def create_tokens
    authorize! :manage, :all
    @user = User.find(params[:user_id])
    respond_with(@user) do |format|
      begin
        params[:token_owner_id] = current_user.id
        msg = @user.add_tokens(params)
        format.html { redirect_to @user, :notice => msg }
      rescue Exception => e
        format.html { render :action => :add_tokens, :error => e.message }
      end
    end
  end

end
