class ApplicationController < ActionController::Base
  protect_from_forgery
  
  def after_sign_in_path_for(resource)
    if current_user
      profile_path
    elsif current_business
      dashboard_path
    end      
  end
  
end
