class ChangeColumnTotalPointsNameOnUserBusinessPoints < ActiveRecord::Migration
  def up
  	rename_column :user_business_points, :total_points, :points
  end

  def down
  	rename_column :user_business_points, :points, :total_points
  end
end
