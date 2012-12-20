class Coupon < ActiveRecord::Base
	belongs_to :benefit
	belongs_to :user
	belongs_to :card
	
	def self.generate_code
		code = '' 
		while code.blank? or Coupon.find_by_code(code)
			code = String.random_alphanumeric(8)
		end
		code
	end
	
	private		
	
		def String.random_alphanumeric(size=16)
			chars = ('a'..'z').to_a + ('A'..'Z').to_a
			(0...size).collect { chars[Kernel.rand(chars.length)] }.join
		end
end
