class CreateCardBusinessPoints < ActiveRecord::Migration
  def change
    create_table :card_business_points do |t|
      t.integer :card_id
      t.integer :business_id
      t.integer :points

      t.timestamps
    end
  end
end
