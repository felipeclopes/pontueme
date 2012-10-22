class BusinessesController < ApplicationController
	def show
		@business = Business.includes(:benefits).find params['id']
	end
end
