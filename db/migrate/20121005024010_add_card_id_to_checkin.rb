class AddCardIdToCheckin < ActiveRecord::Migration
  def change
  	add_column :checkins, :card_id, :integer
  end
end
