class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
	def facebook
		render :text => request.env['rack.auth'].inspect
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
