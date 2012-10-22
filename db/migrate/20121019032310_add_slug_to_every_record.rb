class AddSlugToEveryRecord < ActiveRecord::Migration
  def change
  	Business.find_each(&:save)
  end
end
