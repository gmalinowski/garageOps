class EnforceOrganizationConsistencyOnMembershipPermissions < ActiveRecord::Migration[8.1]
  def change
    add_column :membership_permissions, :organization_id, :bigint, null: false

    add_index :memberships, [ :id, :organization_id ], unique: true
    add_index :locations, [ :id, :organization_id ], unique: true

    remove_foreign_key :membership_permissions, :memberships,
                       column: :membership_id,
                       on_delete: :cascade
    remove_foreign_key :membership_permissions, :locations,
                       column: :location_id,
                       on_delete: :cascade

    add_foreign_key :membership_permissions, :memberships,
                    column: [ :membership_id, :organization_id ],
                    primary_key: [ :id, :organization_id ],
                    on_delete: :cascade,
                    name: "fk_grants_membership_organization"

    add_foreign_key :membership_permissions, :locations,
                    column: [ :location_id, :organization_id ],
                    primary_key: [ :id, :organization_id ],
                    on_delete: :cascade,
                    name: "fk_grants_locations_organization"
  end
end
