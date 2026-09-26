class MakeOrganizationDetailsOptional < ActiveRecord::Migration[8.1]
  def change
    %i[address_line_1 postal_code city country_code phone email tax_id].each do |column|
      change_column_null :organizations, column, true
    end
  end
end
