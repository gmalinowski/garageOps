class AddConstraintsToMembershipPermissions < ActiveRecord::Migration[8.1]
  def change
    add_check_constraint :membership_permissions,
    <<~SQL.squish,
        (scope_type = 'organization' AND location_id IS NULL)
        OR
        (scope_type = 'location' AND location_id IS NOT NULL)
    SQL
    name: "membership_permissions_valid_scope_type"

    add_index :membership_permissions, [ :membership_id, :permission_id, :location_id ], unique: true,
              where: "scope_type = 'location'",
              name: "unique_location_permission_grants"

    add_index :membership_permissions, [ :membership_id, :permission_id ], unique: true,
              where: "scope_type = 'organization'",
              name: "unique_organization_permission_grants"
  end
end
