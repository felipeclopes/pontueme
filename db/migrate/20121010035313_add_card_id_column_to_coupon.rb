class AddCardIdColumnToCoupon < ActiveRecord::Migration
  def change
  	add_column :coupons, :card_id, :integer
  end
end
