class CreateMembershipPermissions < ActiveRecord::Migration[8.1]
  def change
    create_table :membership_permissions do |t|
      t.references :membership, null: false, foreign_key: { on_delete: :cascade }
      t.references :permission, null: false, foreign_key: { on_delete: :cascade }
      t.string :scope_type, null: false, default: 'location'

      t.timestamps
    end
  end
end
