class UserBusinessPoints < ActiveRecord::Base
	belongs_to :business
	belongs_to :user
	
	def add_coupon(coupon)
		self.points = self.points - coupon.points
	end
	
	def add_checkin(checkin)
		self.points = self.points + checkin.points
	end
end
