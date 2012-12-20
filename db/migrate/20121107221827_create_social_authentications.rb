class CreateSocialAuthentications < ActiveRecord::Migration
  def change
    create_table :social_authentications do |t|

      t.timestamps
    end
  end
end
