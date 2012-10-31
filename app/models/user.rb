class User < ActiveRecord::Base
  has_many :checkins
  has_many :coupons
  has_many :cards
  has_many :user_business_points, :class_name => 'UserBusinessPoints'
  has_many :business, :through => :user_business_points

  devise :database_authenticatable, :registerable, :authentication_keys => [:email]
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable, :lockable, :timeoutable and :oauthable
  # devise :database_authenticatable, :oauthable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, :password_changed
  
  after_create :mail_new_user
  
  def add_coupon(benefit, card = nil)
    ubp = self.user_business_points.where(:business == benefit.business_id)      
        
    if ubp.count > 0 && ubp.points >= benefit.checkins_needed         
      coupon = Coupon.new
      coupon.code = Coupon.generate_code
      coupon.points = benefit.checkins_needed
      coupon.active = false
      coupon.benefit = benefit
      coupon.user = self
      coupon.card = card
        
      return coupon.save!
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
