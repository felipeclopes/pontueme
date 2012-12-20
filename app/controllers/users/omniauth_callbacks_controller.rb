#encoding: utf-8
class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
	def facebook
		auth = request.env["omniauth.auth"]
    if current_user.apply_facebook (auth)
      flash[:facebook] = "Autenticado com sucesso!"
    end
    redirect_to profile_url
	end

	def failure
		flash[:facebook] = "Falha ao autenticar o usuário ao Facebook!"
		redirect_to profile_url
	end

	def passthru
	  render :file => "#{Rails.root}/public/404.html", :status => 404, :layout => false
	  # Or alternatively,
	  # raise ActionController::RoutingError.new('Not Found')
	end
end
