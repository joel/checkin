class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me
  
  paginates_per 36
  
  has_many :tokens

  has_many :invitations, :foreign_key => "followed_id"
  
  has_many :relationships, :foreign_key => "follower_id", :dependent => :destroy
  has_many :following, :through => :relationships, :source => :followed

  has_many :reverse_relationships, :foreign_key => "followed_id", :class_name => "Relationship", :dependent => :destroy
  has_many :followers, :through => :reverse_relationships, :source => :follower
    
  validates_presence_of :firstname, :lastname, :gender, :company, :phone
  validates_inclusion_of :gender, :in => %w{ Mr Mlle Mme }, :message => "La civilité n'est pas reconnue"

  after_create :set_authentication_token
  
  before_create :normalize_name
  
  scope :members, where(:admin => false)
  
  mount_uploader :avatar, AvatarUploader

  def nb_of_checkin
    self.tokens.used.count
  end
  
  def nb_of_checkin_label
    msg = "You have #{self.nb_of_checkin} checkin"
    msg << ", you are Major of this place" if major?
    msg
  end
  
  def major?
    self == major
  end
  
  def major
    User.all.sort! { |x,y| y.nb_of_checkin <=> x.nb_of_checkin }[0]
  end
  
  def checkin(token_type_id, motivation_id, checkin_owner_id = nil)
    raise "Your are already checkin" if checkin?
    token = self.tokens.available.first(:conditions => { :token_type_id => token_type_id })
    raise "You have no credit in this type..." unless token
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
    raise "Cost must be set" if h[:price].blank?
    h[:number].to_i.times { self.tokens.create(:cost => h[:price].to_f/h[:number].to_f, :token_type_id => h[:token_type][:token_type_id], :token_owner_id => h[:token_owner_id]) }
    "#{h[:number].to_i} credits has been added"
  end
  
  def checkin?
    !self.tokens.used.first(:conditions=>['? between start_at and stop_at',Time.now.utc]).nil?
  end
  
  def checkin_label
    if self.checkin?
      current_token = self.tokens.used.first(:conditions=>['? between start_at and stop_at',Time.now.utc])
      "(I'm here to #{current_token.token_type.title} for #{current_token.motivation.title})"
    else
      "Current not checkin..."
    end
  end
  
  def checkin_owners_label
    if self.checkin?
      current_token = self.tokens.used.first(:conditions=>['? between start_at and stop_at',Time.now.utc])
      msg = "This credit was given by OWNER_TOKEN and This check-in was done by OWNER_CHECKIN"
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
      "Current not checkin..."
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
  
  def set_authentication_token
    self.reset_authentication_token!
  end    
  
  def normalize_name
    # self.firstname = self.firstname.titlecase
    self.firstname = self.firstname.split(/(\W)/).map(&:capitalize).join
    self.lastname = self.lastname.upcase
  end
  
end
