class CreateCheckins < ActiveRecord::Migration
  def change
    create_table :checkins do |t|
      t.integer :business_id
      t.integer :points
      t.integer :user_id

      t.timestamps
    end
  end
end
