# encoding: utf-8
class CardsController < ApplicationController
  #before_filter :authenticate_user!

  def index
  	@cards = Card.find_all_by_user_id(current_user)
  end

  def create
  	card = Card.find_by_code(params[:code])

  	if card && card.user.nil?
  		current_user.add_card(card)
  	else
  	  return render :status => 401, :json => { :message => "O cartão não existe ou já está cadastrado"}
    end      

    respond_to do |format|
	    format.js { render json: { :card => card, :points => card.card_points.sum("points") } , content_type: 'text/json' }
	  end
  end
end
