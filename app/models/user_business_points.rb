class UserBusinessPoints < ActiveRecord::Base
	belongs_to :business
	belongs_to :user
	
	def add_coupon(coupon)
		self.total_points = self.total_points - coupon.points
	end
	
	def add_checkin(checkin)
		self.total_points = self.total_points + checkin.points
	end
end
