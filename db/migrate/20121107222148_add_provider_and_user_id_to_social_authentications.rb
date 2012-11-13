class AddProviderAndUserIdToSocialAuthentications < ActiveRecord::Migration
  def change
    add_column :social_authentications, :uid, :string
    add_column :social_authentications, :provider, :string
    add_column :social_authentications, :user_id, :integer
  end
end
