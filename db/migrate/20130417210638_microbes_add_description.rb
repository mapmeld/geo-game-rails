class MicrobesAddDescription < ActiveRecord::Migration
  def change
    add_column :microbes, :description, :text
  end
end
