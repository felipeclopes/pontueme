class AddAuthenticationTokenColumnToBusinesses < ActiveRecord::Migration
  def change
    add_column :businesses, :authentication_token, :string
  end
end
