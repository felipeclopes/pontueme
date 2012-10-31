class Checkin < ActiveRecord::Base
	belongs_to :business
	belongs_to :user
	belongs_to :card
	
	before_save :create_dependencies
	after_save  :create_user_business_points, :create_card_business_points
	
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

	def self.sum_points(user, card, business)
		unless user.nil?
			return user.user_business_points.where(:business == business).sum{|p| p.points}
		else 
			return card.card_business_points.where(:business == business).sum{|p| p.points}
		end

		return 0
	end

	protected
	
		def create_user_business_points
			unless self.user_id.nil?
				ubp = UserBusinessPoints.find_by_business_id_and_user_id(self.business_id, self.user_id)
				if ubp.nil?
					ubp = UserBusinessPoints.new(user: self.user, business: self.business, points:0)
				end
				ubp.add_checkin(self)
				ubp.save!
			end
		end

		def create_card_business_points
			unless self.card_id.nil?
				cbp = CardBusinessPoints.find_by_business_id_and_card_id(self.business_id, self.card_id)
				if cbp.nil?
					cbp = CardBusinessPoints.new(card: self.card, business: self.business, points:0)
				end
				cbp.add_checkin(self)
				cbp.save!
			end
		end

		def create_dependencies
			if !self.user.nil? && self.user.new_record?
				user.save
			elsif !self.card.nil? && self.card.new_record?
				card.save
			end
		end
end
