class CardPoint < ActiveRecord::Base
	belongs_to :business
	belongs_to :card
end