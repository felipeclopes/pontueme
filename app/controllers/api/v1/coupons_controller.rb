# encoding: UTF-8
class Api::V1::CouponsController < ApplicationController
	before_filter :authenticate_business!
	
	respond_to :json

	def create
		if (params[:email].nil? && params[:code].nil?) || params[:benefit_id].nil?
			render :status=>400, :json=>{:message=>"A request deve conter o e-mail/cartao do usuario e o id do beneficio"}
			return
		end
	
		user = User.where(:email => params[:email])
		card = Card.where(:code => params[:code])
		benefit = Benefit.where(:id => params[:benefit_id])
		business = current_business

		if user.count == 0 && card.count == 0
			render :status=>401, :json=>{:message=>"Usuário ou cartão fornecido é invalido"}
			return
		end	
		
		if benefit.count == 0
			render :status=>401, :json=>{:message=>"Benefício fornecido é inválido"}
			return
		end
		
		unless user.count == 0
			render :status=>200, :json=> { :result => user.first.add_coupon(benefit.first)}
		end

		unless card.count == 0
			render :status=>200, :json=> { :result => card.first.add_coupon(benefit.first)}
		end
	end
end
