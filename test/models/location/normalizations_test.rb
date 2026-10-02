require "test_helper"

class LocationNormalizationsTest < ActiveSupport::TestCase
  BLANK_TO_NIL = %w[description city country_code phone email postal_code address_line_1 address_line_2]
  STRIP = BLANK_TO_NIL - %w[country_code]

  test "squishes name" do
    location = build(:location, name: "  one    twO  ")
    assert_equal "one twO", location.name
  end

  test "normalizes email" do
    location = build(:location, email: "JAN@exampLE.com   ")
    assert_equal "jan@example.com", location.email
  end

  BLANK_TO_NIL.each do |field|
    test "normalizes blank #{field} to nil" do
      location = build(:location, field => "  ")
      assert_nil location[field]
    end
  end

  STRIP.each do |field|
    test "strip #{field}" do
      location = build(:location, field => "  jeden  ")
      assert_equal "jeden", location[field]
    end
  end

  test "upcase country_code" do
    location = build(:location, country_code: "pl")
    assert_equal "PL", location.country_code
  end
end
