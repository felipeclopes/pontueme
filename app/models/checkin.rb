class Checkin < ActiveRecord::Base
	belongs_to :business
	belongs_to :user
	belongs_to :card
	
	def self.new_checkin(email, code, business)
		checkin = Checkin.new
		checkin.business = business
		checkin.points = 1

		unless email.blank?
			checkin.user = User.retrieve_by_email(email)
		end

		unless code.blank?
			checkin.card = Card.retrieve_by_code(code)

			if checkin.card.user
				checkin.user = checkin.card.user
			end
		end

		checkin
	end
	
end
