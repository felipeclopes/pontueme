class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
	def facebook
		auth = request.env["omniauth.auth"]
    if current_user.apply_facebook (auth)
      flash[:facebook] = "Autenticado com sucesso!"
    end
    redirect_to user_dashboard_index_path
	end

	def failure
		puts request.env['omniauth.error']
    puts request.env['omniauth.error.type']
    puts request.env['omniauth.error.strategy']
	end

	def passthru
	  render :file => "#{Rails.root}/public/404.html", :status => 404, :layout => false
	  # Or alternatively,
	  # raise ActionController::RoutingError.new('Not Found')
	end
end
