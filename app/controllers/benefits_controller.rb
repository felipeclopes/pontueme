#encoding: utf-8
class BenefitsController < ApplicationController
  respond_to :html, :json

  before_filter :authenticate_business!

  def index
    @benefits = current_business.benefits

    respond_with @benefits
  end

  def create
    benefit = current_business.benefits.build(params[:benefit])
    benefit.save!

    render :json => {:benefit => benefit, :status => 200}
  end

  def destroy
    benefit = Benefit.find(params[:id])
    if benefit.destroy
      render :json => {:benefit => benefit, :status => 200}
    else
      render :json => {:benefit => benefit, :status => 404}
    end
  end
end
