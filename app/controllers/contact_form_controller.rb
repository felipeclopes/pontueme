class ContactFormController < ApplicationController
	def new
	end

	def create
		if PontuemeMailer.email_form(params[:email], params[:name], params[:body]).deliver
			#confirm that the e-mail was sent
			UserMailer.email_form_confirmation(params[:email]).deliver
		end

		redirect_to root_path
	end
end
