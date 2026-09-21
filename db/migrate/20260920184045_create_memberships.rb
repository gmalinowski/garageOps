class CreateMemberships < ActiveRecord::Migration[8.1]
  def change
    create_table :memberships do |t|
      t.references :user, null: false, foreign_key: { on_delete: :restrict }
      t.references :organization, null: false, foreign_key: { on_delete: :restrict }
      t.string :title
      t.string :status, null: false, default: "active"

      t.timestamps

      t.index [ :user_id, :organization_id ], unique: true
    end
  end
end
