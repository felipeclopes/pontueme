class Benefit < ActiveRecord::Base
  acts_as_paranoid

	belongs_to :business
end
