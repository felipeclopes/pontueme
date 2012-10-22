class Api::V1::TokensController < ApplicationController
	skip_before_filter :verify_authenticity_token
	
	respond_to :json
	
	def create
	  email = params[:email]
	  password = params[:password]
	  if request.format != :json
		render :status=>406, :json=>{:message=>"The request must be json"}
		return
	   end

	if email.nil? or password.nil?
	   render :status=>400,
			  :json=>{:message=>"The request must contain the business email and password."}
	   return
	end

	@business = Business.find_by_email(email)

	if @business.nil?
	  logger.info("Business #{email} failed signin, business cannot be found.")
	  render :status=>401, :json=>{:message=>"Invalid email or passoword."}
	  return
	end

	# http://rdoc.info/github/plataformatec/devise/master/Devise/Models/TokenAuthenticatable
	# Generates a token if it does not exists and save record
	@business.ensure_authentication_token!

	if not @business.valid_password?(password)
	  logger.info("Business #{email} failed signin, password \"#{password}\" is invalid")
	  render :status=>401, :json=>{:message=>"Invalid email or password."}
	else
	  render :status=>200, :json=>{:token=>@business.authentication_token}
	end
  end

  def destroy
	@business = Business.find_by_authentication_token(params[:id])
	if @business.nil?
	  logger.info("Token not found.")
	  render :status=>404, :json=>{:message=>"Invalid token."}
	else
	  @user.reset_authentication_token!
	  render :status=>200, :json=>{:token=>params[:id]}
	end
  end

end
