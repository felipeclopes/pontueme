class CreateBenefits < ActiveRecord::Migration
  def change
    create_table :benefits do |t|
      t.string :name
      t.text :description
      t.integer :checkins_needed
      t.boolean :enabled
      t.integer :business_id

      t.timestamps
    end
  end
end
