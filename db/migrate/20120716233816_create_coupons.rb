class CreateCoupons < ActiveRecord::Migration
  def change
    create_table :coupons do |t|
      t.integer :points
      t.integer :user_id
      t.integer :benefit_id
      t.string :code

      t.timestamps
    end
  end
end
