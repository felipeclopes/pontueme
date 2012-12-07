#encoding: utf-8
class User < ActiveRecord::Base
  has_many :checkins
  has_many :coupons  
  has_many :cards  
  has_many :social_authentications  
  has_many :businesses, :through => :user_points
  has_many :user_points
  
  scope :with_social_authentication, joins(:social_authentications)

  devise :database_authenticatable, :registerable, :omniauthable, :authentication_keys => [:email]
  
  attr_accessible :email, :password, :password_confirmation, :remember_me, :password_changed
  
  after_create :mail_new_user
  
  def facebook
    puts "======= token ======="
    auth = self.social_authentications.find_by_provider('facebook')
    
    unless auth.nil?
      @fb_user ||= FbGraph::User.me(auth.token).fetch
    end
  end
  
  def apply_facebook(omniauth)
    if (extra = omniauth['extra']['raw_info'] rescue false)
      self.social_authentications.find_or_create_by_provider_and_uid_and_token omniauth['provider'], omniauth['uid'], omniauth['credentials']['token'] do |u|        
        self.birthday = (Date.parse(extra['birthday']) rescue '')
        self.gender = (extra['gender'] rescue '')
        self.location = (extra['location'].name rescue '')
        self.save!
      end
    end
  end
  
  def add_coupon(benefit, card = nil)
    ubps = self.user_points.where(:business_id => benefit.business_id)
        
    if ubps.count > 0 
      ubp = ubps.first

      if ubp.points >= benefit.checkins_needed         
        coupon = Coupon.new
        coupon.code = Coupon.generate_code
        coupon.points = benefit.checkins_needed
        coupon.benefit = benefit
        coupon.user = self
        coupon.card = card
          
        if coupon.save!
          publish_on_facebook benefit
          return true
        end
      end
    end

    return false
  end

  def add_card(card)
    card.user = self

    Coupon.update_all ["user_id = ?", self.id], ["card_id LIKE ?", card.id]
    Checkin.update_all ["user_id = ?", self.id], ["card_id LIKE ?", card.id]

    card.save
  end

  # ------------------------------------
  # Static methods
  # ------------------------------------

  def self.generate_password(size=8)
      chars = ('a'..'z').to_a + ('A'..'Z').to_a
      (0...size).collect { chars[Kernel.rand(chars.length)] }.join
  end

  def self.retrieve_by_email(email)
    user = User.find_by_email(email)

    if user.nil?
      user = User.new
      user.email = email
      user.password = User.generate_password
    end

    return user
  end

  protected
    
    def mail_new_user
      puts '--- user is sending welcome email ---'

      UserMailer.welcome_email(self).deliver
    end
    
    def publish_on_facebook benefit
      if self.facebook
        self.facebook.feed!(
          :message => "Acabei de trocar #{benefit.checkins_needed} de meus pontos por #{benefit.name} de #{benefit.business.name} utilizando o http://pontue.me!",
          :link => "https://pontue.me/businesses/#{benefit.business.slug}",
          :name => "Benefícios #{benefit.business.name} por Pontue.me",                               
          :description => "#{benefit.business.name} - Veja agora os benefícios disponíveis para troca!!",
          :picture => "https://graph.facebook.com/pontueme/picture"
        )
        end
    end

end
