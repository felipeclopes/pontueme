class AddTokenToSocialAuthentications < ActiveRecord::Migration
  def change
    add_column :social_authentications, :token, :string
  end
end
