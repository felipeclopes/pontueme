class Api::V1::CheckinsController < ApplicationController
	before_filter :authenticate_business!
	
	respond_to :json

	def create
		email = params[:email]
		code = params[:code]
		business = current_business

		checkin = Checkin.new_checkin(email, code, business)
		
		if checkin.save!
			points = Checkin.sum_points(checkin.user, checkin.card, checkin.business)
			benefits = Benefit.find_all_by_business_id(current_business)

			render :status=>200, :json=> { :points => points, :benefits => benefits}
			return
		else
			render :status=>401
			return
		end
	end
end
