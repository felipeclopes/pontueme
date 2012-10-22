class ApplicationController < ActionController::Base
  protect_from_forgery
  
  def after_sign_in_path_for(resource)
    if current_user
      user_dashboard_index_path
    elsif current_business
      business_dashboard_index_path
    end      
  end
  
end
