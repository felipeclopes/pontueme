class Card < ActiveRecord::Base
	belongs_to :user

	has_many :checkins
  	has_many :coupons
	has_many :card_business_points, :class_name => 'CardBusinessPoints'
	has_many :business, :through => :card_business_points

	def add_coupon(benefit)
		cbp = CardBusinessPoints.find_by_business_id_and_card_id(benefit.business_id, self)		

		if self.user
			return self.user.add_coupon(benefit, self)
		end

		if cbp.points >= benefit.checkins_needed
			coupon = Coupon.new
	        coupon.code = Coupon.generate_code
	        coupon.points = benefit.checkins_needed
	        coupon.active = false
	        coupon.benefit = benefit
			coupon.card = self         
			coupon.user = self.user

			return coupon.save!
		end
	end

	# ------------------------------------
	# Static methods
	# ------------------------------------

	def self.retrieve_by_code(code)
		card = Card.find_by_code(code)

	    if card.nil?
	      card = Card.new
	      card.code = code
	    end

	    return card
	end

end
