class AddDetailsToOrganizations < ActiveRecord::Migration[8.1]
  def change
    add_column :organizations, :slug, :string, null: false
    add_column :organizations, :address_line_1, :string, null: false
    add_column :organizations, :address_line_2, :string
    add_column :organizations, :postal_code, :string, null: false
    add_column :organizations, :city, :string, null: false
    add_column :organizations, :country_code, :string, null: false
    add_column :organizations, :phone, :string, null: false
    add_column :organizations, :email, :string, null: false
    add_column :organizations, :website, :string
    add_column :organizations, :tax_id, :string, null: false
    add_column :organizations, :regon, :string
    add_column :organizations, :active, :boolean, null: false, default: true

    add_index :organizations, :slug, unique: true
    add_index :organizations, :tax_id, unique: true
  end
end
