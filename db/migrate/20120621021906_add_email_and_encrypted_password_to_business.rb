class AddEmailAndEncryptedPasswordToBusiness < ActiveRecord::Migration
  def change
    add_column :businesses, :email, :string
    add_column :businesses, :encrypted_password, :string
  end
end
