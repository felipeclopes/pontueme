class CreateSocialAuthorizations < ActiveRecord::Migration
  def change
    create_table :social_authorizations do |t|

      t.timestamps
    end
  end
end
