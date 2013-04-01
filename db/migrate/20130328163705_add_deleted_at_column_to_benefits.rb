class AddDeletedAtColumnToBenefits < ActiveRecord::Migration
  def change
    add_column :benefits, :deleted_at, :time
  end
end
