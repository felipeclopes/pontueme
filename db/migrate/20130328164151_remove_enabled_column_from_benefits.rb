class RemoveEnabledColumnFromBenefits < ActiveRecord::Migration
  def up
    remove_column :benefits, :enabled
  end

  def down
    add_column :benefits, :enabled, :boolean
  end
end
