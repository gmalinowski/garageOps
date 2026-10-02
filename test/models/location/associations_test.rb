require "test_helper"

class LocationAssociationsTest < ActiveSupport::TestCase
  test "belongs to organization" do
    location = build(:location, organization: nil)

    assert location.invalid?
    assert location.errors.of_kind?(:organization, :blank)
  end

  test "returns organizations the locations belongs to" do
    organization = create(:organization)
    create(:organization)
    location = create(:location, organization: organization)

    assert_equal location.organization, organization
  end
end
