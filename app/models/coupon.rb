class Coupon < ActiveRecord::Base
	belongs_to :benefit
	belongs_to :user
	belongs_to :card
	
	after_save  :update_user_business_points, :update_card_business_points
	
	def self.generate_code
		code = '' 
		while code.blank? or Coupon.find_by_code(code)
			code = String.random_alphanumeric(8)
		end
		code
	end
	
	protected
	
		def update_user_business_points
			unless self.user.nil?
				ubp = UserBusinessPoints.find_by_business_id_and_user_id(self.benefit.business_id, self.user_id)			
				ubp.add_coupon(self)
				ubp.save!
			end
		end

		def update_card_business_points
			if self.user.nil? && !self.card.nil?
				cbp = CardBusinessPoints.find_by_business_id_and_card_id(self.benefit.business_id, self.card_id)			
				cbp.add_coupon(self)
				cbp.save!
			end
		end
	
	private		
	
		def String.random_alphanumeric(size=16)
			chars = ('a'..'z').to_a + ('A'..'Z').to_a
			(0...size).collect { chars[Kernel.rand(chars.length)] }.join
		end
end
