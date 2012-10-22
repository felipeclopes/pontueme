class CouponsController < ApplicationController
	before_filter :authenticate_user!, :only => :show
	
	def show
		@coupon = Coupon.find(params[:id])
	end
end
