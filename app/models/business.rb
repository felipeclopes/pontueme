class Business < ActiveRecord::Base
	has_many :checkins
	has_many :coupons
	has_many :users, :through => :user_points
	has_many :user_points
	
	has_many :benefits	
	
	devise :database_authenticatable, :token_authenticatable, :authentication_keys => [:email]

	extend FriendlyId
	friendly_id :name, :use => :slugged
end
