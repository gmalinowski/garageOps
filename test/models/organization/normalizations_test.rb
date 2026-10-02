require "test_helper"

class OrganizationNormalizationsTest < ActiveSupport::TestCase
  test "stores blank tax ids as nil for multiple organizations" do
    first = Organization.create!(name: "First blank tax id", tax_id: "")
    second = Organization.create!(name: "Second blank tax id", tax_id: "   ")

    assert_nil first.reload.tax_id
    assert_nil second.reload.tax_id
  end

  test "normalizes email" do
    org = build(:organization, email: "  CONTact@eXAmple.com ")
    org.valid?
    assert_equal "contact@example.com", org.email
  end

  test "normalizes country_code" do
    org = build(:organization, country_code: "  pL ")
    org.valid?
    assert_equal "PL", org.country_code
  end

  test "normalizes tax_id" do
    org = build(:organization, tax_id: " DK99999999   ")
    org.valid?
    assert_equal "DK99999999", org.tax_id
  end

  test "squishes name field" do
    org = build(:organization, name: "My    work  shop  ")
    assert_equal "My work shop", org.name
  end

  %w[email country_code tax_id description website phone address_line_1 address_line_2 city postal_code regon].each do |field|
    test "normalizes blank #{field} to nil" do
      org = build(:organization)
      org[field] = "    "
      assert_nil org[field]
    end
  end
end
