# encoding: utf-8
class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
  :recoverable, :rememberable, :trackable, :validatable, :rpx_connectable, :token_authenticatable

  # Setup accessible (or protected) attributes for your model
  # TODO To restore
  attr_accessible :email, :password, :password_confirmation, :remember_me, :gender, :firstname, :lastname, :company, :phone, :twitter, :avatar, :bio, :admin

  # # TODO To Remove
  # attr_accessible :email, :password, :password_confirmation, :remember_me, :gender, :firstname, :lastname, :company, :phone, :twitter, :avatar,
  # :encrypted_password, :reset_password_token, :remember_created_at, :sign_in_count, :current_sign_in_at, :last_sign_in_at, :current_sign_in_ip, :last_sign_in_ip, :created_at, :updated_at, :rpx_identifier, :authentication_token, :admin

  paginates_per 36

  has_many :tokens, :dependent => :destroy
  has_many :invitations, :foreign_key => "followed_id", :dependent => :destroy
  has_many :relationships, :foreign_key => "follower_id", :dependent => :destroy
  has_many :following, :through => :relationships, :source => :followed
  has_many :reverse_relationships, :foreign_key => "followed_id", :class_name => "Relationship", :dependent => :destroy
  has_many :followers, :through => :reverse_relationships, :source => :follower

  validates_presence_of :firstname, :lastname, :company, :phone, :email
  # validates_presence_of :gender
  # validates_inclusion_of :gender, :in => %w{ Mr Mlle Mme }, :message => "La civilité n'est pas reconnue"

  after_create :set_authentication_token

  before_create :normalize_name
  
  before_destroy :clean_token

  scope :members, where(:admin => false)

  mount_uploader :avatar, AvatarUploader

  def nb_of_checkin
    self.tokens.used.count
  end

  def nb_of_checkin_label
    msg = I18n.t('users.nb_checkin', :nb => self.nb_of_checkin)
    msg << ", " + I18n.t('users.major') if major?
    msg
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

  # # TODO Temporary method
  # def self.import(data)
  #   begin
  #     data.each do |p|
  #       logger.info "! %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% - #{p['email']} - %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%"
  #       logger.info p['email']
  #       already = User.where(:email=>p['email'])
  #       User.destroy(already.first.id) if already.exists?
  #       user = User.new(:email => p['email'],
  #         :password => 'foobarzone',
  #         :password_confirmation => 'foobarzone',
  #         # :encrypted_password => p['encrypted_password'],
  #         :reset_password_token => p['reset_password_token'],
  #         :remember_created_at => p['remember_created_at'],
  #         :sign_in_count => p['sign_in_count'],
  #         :current_sign_in_at => p['current_sign_in_at'],
  #         :last_sign_in_at => p['last_sign_in_at'],
  #         :current_sign_in_ip => p['current_sign_in_ip'],
  #         :last_sign_in_ip => p['last_sign_in_ip'],
  #         :created_at => p['created_at'],
  #         :updated_at => p['updated_at'],
  #         :rpx_identifier => p['rpx_identifier'],
  #         :authentication_token => p['authentication_token'],
  #         :firstname => p['firstname'],
  #         :lastname => p['lastname'],
  #         :gender => p['gender'],
  #         :company => p['company'],
  #         :phone => p['phone'],
  #         :admin => p['admin'])
  #       user.save!
  #       user.update_attribute(:encrypted_password, p['encrypted_password']) unless p['encrypted_password'].blank?
  #       file_root = "/var/www/checkin/shared"
  #       if !p['avatar']['url'].nil? and File.exist?(file_root + p['avatar']['url'])
  #         user.avatar = File.new(file_root + p['avatar']['url'])  
  #         logger.info "!! RRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRR - #{p['email']} - RRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRR"
  #         user.save!
  #         logger.info "!! RRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRR - #{p['email']} - RRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRR"
  #       end
  #     end
  #     # Tokens
  #     data.each do |p|
  #       logger.info "!! %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% - #{p['email']} - %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%"
  #       user = User.where(:email=>p['email']).first
  #       logger.info p['tokens']
  #       p['tokens'].each do |token|
  #         logger.info token
  #         ['checkin_owner_id','token_owner_id'].each do |method|
  #           if User.where(:email=>token[method]).exists?
  #             token.merge!(method.to_sym => User.where(:email=>token[method]).first.id)
  #           else
  #             token.merge!(method.to_sym => nil)
  #           end
  #         end
  #         user.tokens.create(token)
  #       end
  #     end
  #     # Invitations
  #     data.each do |p|
  #       logger.info "!! %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% - #{p['email']} - %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%"
  #       user = User.where(:email=>p['email']).first
  #       logger.info p['invitations']
  #       p['invitations'].each do |invitation|
  #         logger.info invitation
  #         ['follower_id','followed_id'].each do |method|
  #           if User.where(:email=>invitation[method]).exists?
  #             invitation.merge!(method.to_sym => User.where(:email=>invitation[method]).first.id)
  #           else
  #             invitation.merge!(method.to_sym => nil)
  #           end
  #         end
  #         user.invitations.create(invitation)
  #       end
  #     end
  #     # Following
  #     data.each do |p|
  #       logger.info "!! %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% - #{p['email']} - %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%"
  #       user = User.where(:email=>p['email']).first
  #       logger.info p['following']
  #       p['following'].each do |relationship|
  #         logger.info relationship
  #         ['follower_id','followed_id'].each do |method|
  #           if User.where(:email=>relationship[method]).exists?
  #             relationship.merge!(method.to_sym => User.where(:email=>relationship[method]).first.id)
  #           else
  #             relationship.merge!(method.to_sym => nil)
  #           end
  #         end
  #         user.following.create(relationship)
  #       end
  #     end
  #     # Followers
  #     data.each do |p|
  #       logger.info "!! %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% - #{p['email']} - %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%"
  #       user = User.where(:email=>p['email']).first
  #       logger.info p['followers']
  #       p['followers'].each do |relationship|
  #         logger.info relationship
  #         ['follower_id','followed_id'].each do |method|
  #           if User.where(:email=>relationship[method]).exists?
  #             relationship.merge!(method.to_sym => User.where(:email=>relationship[method]).first.id)
  #           else
  #             relationship.merge!(method.to_sym => nil)
  #           end
  #         end
  #         user.followers.create(relationship)
  #       end
  #     end
  #   rescue Exception => e
  #     logger.info "************************************************************************"
  #     logger.info e.message
  #     logger.info "************************************************************************"
  #   end
  # end

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
