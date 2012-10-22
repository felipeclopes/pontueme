class BusinessDashboardController < ApplicationController
  before_filter :authenticate_business!
  
  def index
    @checkins = Checkin.find_all_by_business_id(current_business)
    @coupons = Coupon.includes(:benefit).find(:all, :conditions => ['benefits.business_id = ?', current_business])
  end
end
