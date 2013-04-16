class CreateInstagramPhotos < ActiveRecord::Migration
  def change
    create_table :instagram_photos do |t|

      # from Instagram API
      t.string :created_time
      t.string :instagram_photo_id
      t.float :latitude
      t.float :longitude
      t.string :image_url
      t.text :caption

      t.references :instagram_user

      t.timestamps
    end

    add_index :instagram_photos, :instagram_user_id

  end
end
