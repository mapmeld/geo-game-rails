class CreateMicrobes < ActiveRecord::Migration
  def change
    create_table :microbes do |t|

      t.string :name
      t.string :tag

      t.timestamps
    end
  end
end
