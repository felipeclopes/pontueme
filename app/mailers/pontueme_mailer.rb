class PontuemeMailer < ActionMailer::Base
  def email_form(email, name, body)  	
  	mail(
  	  	:to => 'contato@pontue.me', 
  	  	:from => email,
  		:subject => name + " entrou em contato.",
  		:body => body)
  end  
end
