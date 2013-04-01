class Benefit < ActiveRecord::Base
  acts_as_paranoid

	belongs_to :business

  validates :name, :description, :checkins_needed, :presence => true
end
