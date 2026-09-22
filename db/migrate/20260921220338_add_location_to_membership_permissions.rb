class AddLocationToMembershipPermissions < ActiveRecord::Migration[8.1]
  def change
    add_reference :membership_permissions, :location, null: true, foreign_key: { on_delete: :cascade }
  end
end
