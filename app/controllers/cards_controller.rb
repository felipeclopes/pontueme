# encoding: utf-8
class CardsController < ApplicationController
  before_filter :authenticate_user!

  def index
  	@cards = Card.find_all_by_user_id(current_user)
  end

  def create
  	card = Card.find_by_code(params[:code])

  	if card && card.user.nil?
  		current_user.add_card(card)
  	else
      respond_to do |format|
        format.html  { redirect_to cards_path, :notice => 'O cartão não existe ou já está cadastrado' }
      end
      return;
    end      

    respond_to do |format|
        format.html  { redirect_to cards_path, :notice => 'O cartão foi cadastrado com sucesso' }
    end
  end
end
