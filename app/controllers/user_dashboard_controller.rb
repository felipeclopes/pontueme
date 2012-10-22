class UserDashboardController < ApplicationController
	before_filter :authenticate_user!

	def index		
		@abc = current_user.checkins.all
	
		@checkins = Checkin.includes(:business).order("created_at DESC").find_all_by_user_id(current_user)
		@coupons = Coupon.find_all_by_user_id(current_user)
		@ubps = UserBusinessPoints.find_all_by_user_id(current_user)
		@business = Business.where(:checkins_user_id == current_user).select("DISTINCT name, id").to_a
	end

end
