class SocialAuthorization < ActiveRecord::Base
	belongs_to  :user
	validates_presence_of :user_id, :uidm, :provider
	validates_uniqueness_of :uid, :scope => :provider
end
