class NotificationsController < ApplicationController
  
  load_and_authorize_resource
  
  respond_to :html
  
  def index
    @notifications = Notification.order('created_at desc').page params[:page]
    respond_with(@notifications)
  end

  def show
    respond_with(@notification)
  end

  def new
    @notification = Notification.new(:user_id=>current_user.person.id)
    respond_with(@notification)
  end

  def create
    respond_with(@notification) do |format|
      if @notification.save
        format.html { redirect_to(@notification, :notice => 'Notification was successfully created.') }
      else
        format.html { render :action => "new" }
      end
    end
  end

end
