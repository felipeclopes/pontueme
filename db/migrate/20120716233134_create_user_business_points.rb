class CreateUserBusinessPoints < ActiveRecord::Migration
  def change
    create_table :user_business_points do |t|
      t.integer :user_id
      t.integer :business_id
      t.integer :total_points

      t.timestamps
    end
  end
end
