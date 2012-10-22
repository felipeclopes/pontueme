class UserMailer < ActionMailer::Base
  default from: "contato@pontue.me"
  
  def welcome_email(user)
    @user = user
    mail(:to => user.email, :subject => "Bem vindo ao pontue.me")
  end

  def email_form_confirmation(email)
  	mail(:to => email, :subject => "Pontue.me, envio de e-mail")
  end
end
