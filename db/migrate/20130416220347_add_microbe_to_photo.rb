class AddMicrobeToPhoto < ActiveRecord::Migration
  def change
    add_column :instagram_photos, :microbe_id, :integer
    add_index :instagram_photos, :microbe_id
  end
end
