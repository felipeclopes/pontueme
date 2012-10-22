class User < ActiveRecord::Base
  has_many :checkins
  has_many :coupons
  has_many :cards
  has_many :user_business_points

  devise :database_authenticatable, :registerable, :authentication_keys => [:email]
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable, :lockable, :timeoutable and :oauthable
  # devise :database_authenticatable, :oauthable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me
  
  after_create :mail_new_user
  
  def add_coupon(benefit, card = nil)
      ubp = UserBusinessPoints.find_by_business_id_and_user_id(benefit.business_id, self)
        
      if !ubp.nil? && ubp.total_points >= benefit.checkins_needed         
        coupon = Coupon.new
        coupon.code = Coupon.generate_code
        coupon.points = benefit.checkins_needed
        coupon.active = false
        coupon.benefit = benefit
        coupon.user = self
        coupon.card = card
          
        return coupon.save!
      end
  end

  def add_card(card)
    card.user = self

    CardBusinessPoints.find_all_by_card_id(card).each do |cbp|
      ubp = UserBusinessPoints.find_by_business_id_and_user_id(cbp.business_id, self)

      if ubp.nil?
        ubp = UserBusinessPoints.new(user: self, business: cbp.business, total_points:0)
      end

      ubp.total_points = ubp.total_points + cbp.points
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
