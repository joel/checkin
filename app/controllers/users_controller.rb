class UsersController < ApplicationController
  # load_and_authorize_resource

  respond_to :html
  respond_to :xml, :json, :only => [:index, :current_checkin, :import]

  before_filter :authenticate_user!, :excpet => [:import]
  before_filter :safe_user, :only => [:edit,:update,:destroy]
  before_filter :secure_invitation, :only => [:accept_invitation,:denied_invitation]

  def index
    _users = User.where("id <> ?",current_user.id).order('created_at asc').all
    _users << current_user
    # _users << User.find_by_id(current_user.id)
    # puts "current_user : #{current_user.email}"
    _users.reverse!
    @users = Kaminari.paginate_array(_users).page(params[:page])
    respond_with(@users)
  end

  def current_checkin
    @users = Kaminari.paginate_array(User.all(:order=>'firstname').select { |p| p.checkin? }).page(params[:page])
    respond_with(@users) do |format|
      format.html { render :action => :index }
      format.json { render :action => :index }
      format.xml { render :action => :index }
    end
  end

  # def checkin_label
  #   @user = User.select('id,process_done,checkin_label_msg').where(:id => params[:id]).first
  #   result = { :treated => 0, :user_id => @user.id, :treated => 1, :checkin_label => @user.checkin_label_msg }
  #   result.merge!(:treated => 1) if @user.process_done # No have information for highlight !
  #   respond_with(@users) do |format|
  #     format.json { render :json => result }
  #   end
  # end

  def denied_invitation
    @invitation.denied!
    flash[:notice] = "Ok bye bye #{@invitation.follower.name} !"
    respond_with(@user)
  end

  def accept_invitation
    @invitation.accept!
    flash[:success] = "You follow #{@invitation.follower.name} now !"
    respond_with(@user)
  end

  def request_an_invitation
    @followed = User.find(params[:id])
    @follower = current_user
    @followed.invitation!(@follower)
    flash[:success] = "Your request has been sent with succes"
    respond_with(@user) do |format|
      format.html { redirect_to users_path }
    end
  end

  def show
    @user = User.find(params[:id])
    respond_with(@user)
  end

  def edit
    authorize! :edit, @user
    respond_with(@user)
  end

  def update
    authorize! :update, @user
    respond_with(@user) do |format|
      if @user.update_attributes(params[:user])
        format.html { redirect_to(@user, :notice => 'User was successfully updated.') }
      else
        format.html { render :action => "edit" }
      end
    end
  end

  def destroy
    authorize! :destroy, @user
    @user.destroy
    respond_with do |format|
      format.html { redirect_to(users_url) }
    end
  end

  private

  def safe_user
    @user = (current_user.is_admin?) ? User.find(params[:id]) : current_user
  end

  def secure_invitation
    @user = current_user
    @invitation = Invitation.find(params[:id])
    unless @user == @invitation.followed
      respond_with do |format|
        flash[:error] = "This operation is forbiden"
        format.html { redirect_to :action => :show }
      end
    end
  end

end