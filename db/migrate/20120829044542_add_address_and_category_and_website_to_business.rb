class AddAddressAndCategoryAndWebsiteToBusiness < ActiveRecord::Migration
  def change
    add_column :businesses, :address, :string
    add_column :businesses, :website, :string
    add_column :businesses, :category, :string
  end
end
