class AddSlugToLocations < ActiveRecord::Migration[8.1]
  def change
    add_column :locations, :slug, :string, null: false

    add_index :locations, %i[organization_id slug], unique: true
  end
end
