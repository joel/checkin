# encoding: utf-8
class User < ActiveRecord::Base
  include CheckinLabel
  
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
  :recoverable, :rememberable, :trackable, :token_authenticatable

  # devise :validatable unless omniauthable?

  # Setup accessible (or protected) attributes for your model
  # TODO To restore
  attr_accessible :email, :password, :password_confirmation, :remember_me, :gender, :firstname, :lastname, :company, :phone, :twitter, :avatar, :bio, :admin,
    :checkin_label_msg, :process_done, :username

  # # TODO To Remove
  # attr_accessible :email, :password, :password_confirmation, :remember_me, :gender, :firstname, :lastname, :company, :phone, :twitter, :avatar,
  # :encrypted_password, :reset_password_token, :remember_created_at, :sign_in_count, :current_sign_in_at, :last_sign_in_at, :current_sign_in_ip, :last_sign_in_ip, :created_at, :updated_at, :authentication_token, :admin

  paginates_per 36

  has_many :tokens, :dependent => :destroy
  has_many :invitations, :foreign_key => "followed_id", :dependent => :destroy
  has_many :relationships, :foreign_key => "follower_id", :dependent => :destroy
  has_many :following, :through => :relationships, :source => :followed
  has_many :reverse_relationships, :foreign_key => "followed_id", :class_name => "Relationship", :dependent => :destroy
  has_many :followers, :through => :reverse_relationships, :source => :follower
  has_many :authentications
 
  validates_presence_of :firstname, :lastname, :company, :phone, :email, :username
  validates_length_of       :email, :within => 6..100 #r@a.wk
  validates_uniqueness_of   :email, :case_sensitive => false
  validates_format_of       :email, :with => /^([^\s]+)((?:[-a-z0-9]\.)[a-z]{2,})$/i # /^\S+\@(\[?)[a-zA-Z0-9\-\.]+\.([a-zA-Z]{2,4}|[0-9]{1,4})(\]?)$/ix  # /^\S+@[a-zA-Z0-9\.\-]+\.[a-zA-Z]{2,6}$/
  validates_uniqueness_of   :username, :case_sensitive => false
  # validates_format_of       :username, :with => /^\w+$/i, :message => "can only contain letters and numbers."
  validates_format_of       :username, :with => /^[-A-Za-z0-9@_.]*$/, :message => "can only contain letters and numbers."
  
  # validates_presence_of :gender
  # validates_inclusion_of :gender, :in => %w{ Mr Mlle Mme }, :message => "La civilité n'est pas reconnue"
  # validates_length_of       :firstname,     :maximum => 100
  # validates_length_of       :lastname,     :maximum => 100
  # validates_presence_of     :mobile
  # validates_presence_of     :email
  validates_length_of       :email, :within => 6..100 #r@a.wk
  validates_uniqueness_of   :email, :case_sensitive => false
  validates_format_of       :email, :with => /^\S+\@(\[?)[a-zA-Z0-9\-\.]+\.([a-zA-Z]{2,4}|[0-9]{1,4})(\]?)$/ix

  # validates_inclusion_of :gender, :in => %w{ Mr Mlle Mme }, :message => "La civilité n'est pas reconnue"

  after_create :set_authentication_token

  before_create :normalize_name
  
  before_destroy :clean_token

  scope :members, where(:admin => false)

  mount_uploader :avatar, AvatarUploader
  
  def password_required?  
    (authentications.empty? || !password.blank?)  
  end
  
  def self.user_already_exist?(omniauth)
    (user = User.find_by_email(omniauth['user_info']['email']) rescue nil)
    return user if user
    (user = User.find_by_username(omniauth['user_info']['nickname']) rescue nil)
    user ||= User.new
    return user
  end
  
  def apply_omniauth(omniauth)
    self.email = omniauth['user_info']['email'] if email.blank?
    # self.username = omniauth['user_info']['nickname'] if username.blank?
    authentications.build(:provider => omniauth['provider'], :uid => omniauth['uid'])
    case omniauth['provider']
    when 'google'
      self.username = omniauth['user_info']['name'] if self.username.blank?
    when 'github'
      self.username = omniauth['user_info']['nickname'] if self.username.blank?
    when 'facebook'
      self.username = omniauth['user_info']['nickname'] if self.username.blank?
      self.firstname = omniauth['user_info']['first_name'] if self.firstname.blank?
      self.lastname = omniauth['user_info']['last_name'] if self.lastname.blank?
    when 'twitter'
      self.username = omniauth['user_info']['nickname'] if self.username.blank?
      self.avatar = omniauth['user_info']['image'] if self.avatar.blank?
    end
  end
  
  def nb_of_checkin
    self.tokens.used.count
  end

  def nb_checkin_label
    self.checkin_label_msg.try(:html_safe)
  end

  def major?
    self == major
  end

  def major
    User.all.sort! { |x,y| y.nb_of_checkin <=> x.nb_of_checkin }[0]
  end

  def checkin(token_type_id, motivation_id, checkin_owner_id = nil)
    raise I18n.t('users.checkin.already') if checkin?
    token = self.tokens.available.first(:conditions => { :token_type_id => token_type_id })
    raise I18n.t('users.checkin.no_credit') unless token
    msg = token.checkin(motivation_id, checkin_owner_id)
    NotifierMailer.safe_sending { NotifierMailer.checkin_notification(self.id, token.token_type.title, token.motivation.title) }
    self.followers.all.each do |follower|
      NotifierMailer.safe_sending { NotifierMailer.notify_followers(follower.id, self.id, token.token_type.title, token.motivation.title) }
    end
    msg
  end

  def tokens_avalaible?(type_id)
    remain_tokens(type_id) > 0
  end

  def remain_tokens(type_id)
    self.tokens.available.count(:conditions => { :token_type_id => type_id })
  end

  def invitation!(follower)
    self.invitations.create(:follower_id => follower.id) unless invitation?(follower)
  end

  def invitation?(follower)
    self.invitations.find_by_follower_id(follower.id)
  end

  def following?(followed)
    self.relationships.find_by_followed_id(followed)
  end

  def follow!(followed)
    self.relationships.create!(:followed_id => followed.id) unless following?(followed)
  end

  def unfollow!(followed)
    self.relationships.find_by_followed_id(followed).destroy if following?(followed)
  end

  def name
    "#{self.firstname} #{self.lastname}"
  end

  def not_me?(u)
    u != self
  end

  def me?(u)
    !not_me?(u)
  end

  def self.account_already_exist?(current_user)
    User.find_by_user_id(current_user.id)
  end

  def add_tokens(h)
    raise I18n.t('users.add_tokens.cost_missing') if h[:price].blank?
    h[:number].to_i.times { self.tokens.create(:used => false, :cost => h[:price].to_f/h[:number].to_f, :token_type_id => h[:token_type][:token_type_id], :token_owner_id => h[:token_owner_id]) }
    I18n.t('users.add_tokens.credit_added', :number => h[:number].to_i)
  end

  def checkin?
    !self.tokens.used.first(:conditions=>['? between start_at and stop_at',Time.now.utc]).nil?
  end

  def checkin_label
    if self.checkin?
      current_token = self.tokens.used.first(:conditions=>['? between start_at and stop_at',Time.now.utc])
      I18n.t('users.checkin_label.checkin', :token_type => current_token.token_type.title, :motivation => current_token.motivation.title)
    else
      I18n.t('users.checkin_label.no_checkin')
    end
  end

  def checkin_owners_label
    if self.checkin?
      current_token = self.tokens.used.first(:conditions=>['? between start_at and stop_at',Time.now.utc])
      msg = I18n.t('users.checkin_owners_label.msg')
      current_token.token_owner ? msg.gsub!('OWNER_TOKEN',current_token.token_owner.name) : msg.gsub!('OWNER_TOKEN',"Nobody")
      if current_token.checkin_owner
        if current_token.checkin_owner == self
          msg.gsub!('OWNER_CHECKIN',"HimSelf")
        else
          msg.gsub!('OWNER_CHECKIN',current_token.checkin_owner.name)
        end
      else
        msg.gsub!('OWNER_CHECKIN',"Nobody")
      end
      msg
    else
      I18n.t('users.checkin_label.no_checkin')
    end
  end

  def is_admin?
    self.admin
  end

  def is_guest?
    false
  end

  def show_button_folow?(other)
    show = true
    # It have already received an invitation
    if other.invitations.find_by_follower_id(self.id)
      show = false
    end
    # It's already follow by this person
    if self.following?(other) or other.following?(self) 
      show = false
    end
    return show
  end

  private 

  def clean_token
    Token.where(:checkin_owner_id => self.id).all.each  do |token|
      token.update_attribute(:checkin_owner_id,nil)
    end
  end
  
  def set_authentication_token
    self.reset_authentication_token!
  end    

  def normalize_name
    # self.firstname = self.firstname.titlecase
    self.firstname = self.firstname.split(/(\W)/).map(&:capitalize).join
    self.lastname = self.lastname.upcase
  end

end
