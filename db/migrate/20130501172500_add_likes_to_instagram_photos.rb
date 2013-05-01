class AddLikesToInstagramPhotos < ActiveRecord::Migration
  def change
    add_column :instagram_photos, :likes, :integer
  end
end
