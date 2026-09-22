class CreatePermissions < ActiveRecord::Migration[8.1]
  def change
    create_table :permissions do |t|
      t.string :key, null: false, index: { unique: true }
      t.string :name, null: false, index: { unique: true }
      t.text :description

      t.timestamps
    end
  end
end
