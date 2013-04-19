class PhotosAddScore < ActiveRecord::Migration
  def change
    add_column :instagram_photos, :score, :integer
  end
end
