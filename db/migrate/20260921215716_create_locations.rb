class CreateLocations < ActiveRecord::Migration[8.1]
  def change
    create_table :locations do |t|
      t.references :organization, null: false, foreign_key: true

      t.string :name, null: false
      t.text :description
      t.string :phone, null: false
      t.string :email, null: false
      t.string :address_line_1, null: false
      t.string :address_line_2
      t.string :postal_code, null: false
      t.string :city, null: false
      t.string :country_code, null: false

      t.timestamps

      t.index [ :organization_id, :name ], unique: true
    end
  end
end
