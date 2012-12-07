class ContactFormController < ApplicationController
	def create
	  puts "- - - - - - -"
	  puts params.inspect
	  puts "- - - - - - -"
	  	  
		if PontuemeMailer.email_form(params[:email], params[:name], params[:body]).deliver
			#confirm that the e-mail was sent
			if UserMailer.email_form_confirmation(params[:email]).deliver
  		  respond_to do |format|
    	    format.js { render json: { :type => "success", :message => "O email foi enviado com sucesso!"} , content_type: 'text/json' }
    	  end
  		else
  		  respond_to do |format|
    	    format.js { render json: { :type => "error", :message => "Erro ao enviar o e-mail!"} , content_type: 'text/json' }
    	  end
  		end
		end
	end
end
