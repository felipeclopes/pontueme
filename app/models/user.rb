class User < ActiveRecord::Base
  has_many :checkins
  has_many :coupons
  has_many :cards
  has_many :user_business_points, :class_name => 'UserBusinessPoints'
  has_many :business, :through => :user_business_points

  has_many :social_authentications

  devise :database_authenticatable, :registerable, :omniauthable, :authentication_keys => [:email]
  
  attr_accessible :email, :password, :password_confirmation, :remember_me, :password_changed
  
  after_create :mail_new_user
  
  def facebook
    @fb_user ||= FbGraph::User.me(self.authentications.find_by_provider('facebook').token)
  end
  
  def apply_facebook(omniauth)
    if (extra = omniauth['extra']['raw_info'] rescue false)
      social_authentications.find_or_create_by_provider_and_uid omniauth['provider'], omniauth['uid'] do |u|        
        self.birthday = (Date.parse(extra['birthday']) rescue '')
        self.gender = (extra['gender'] rescue '')
        self.location = (extra['location'].name rescue '')
        self.save!
      end
    end
  end
  
  def add_coupon(benefit, card = nil)
    ubps = self.user_business_points.where('business_id' => benefit.business_id)
        
    if ubps.count > 0 
      ubp = ubps.first

      if ubp.points >= benefit.checkins_needed         
        coupon = Coupon.new
        coupon.code = Coupon.generate_code
        coupon.points = benefit.checkins_needed
        coupon.active = false
        coupon.benefit = benefit
        coupon.user = self
        coupon.card = card
          
        current_user.facebook.feed!(
          :message => 'Acabei de trocar meus pontos no Pontue.me por #{benefit.name} na #{ubp.business.name}!',
          :name => 'Pontue.me'
        )
          
        return coupon.save!
      end
    end

    return false
  end

  def add_card(card)
    card.user = self

    card.card_business_points.each do |cbp|
      ubp = self.user_business_points.where(:business_id => cbp.business)

      if ubp.count == 0
        ubp = UserBusinessPoints.new(user: self, business: cbp.business, points:0)
      else
        ubp = ubp.first
      end

      ubp.points = ubp.points + cbp.points
      ubp.save
    end

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

end
