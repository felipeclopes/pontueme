class UserDashboardController < ApplicationController
	before_filter :authenticate_user!

	def index		
		@checkins = current_user.checkins.joins(:business).to_a
		@coupons = current_user.coupons.to_a
		@ubps = current_user.user_business_points.includes(:business).to_a
	end

end
