class CreateInstagramUsers < ActiveRecord::Migration
  def change
    create_table :instagram_users do |t|

      # Returned from Instagram API
      t.string :username
      t.string :profile_picture
      t.string :instagram_user_id
      t.string :full_name

      t.integer :score
      t.timestamps
    end
  end
end
