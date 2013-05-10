class AddCategoryToPhoto < ActiveRecord::Migration
  def change
    add_column :instagram_photos, :category_id, :integer
    add_index :instagram_photos, :category_id
  end
end
