require "test_helper"

class OrganizationTest < ActiveSupport::TestCase

  test "is valid with a name" do
    organization = Organization.new(name: "Test organization")

    assert organization.valid?
  end

  test "requires a name" do
    organization = Organization.new(name: "")

    assert_not organization.valid?
    assert organization.errors.of_kind?(:name, :blank)
  end

  test "requires a unique name" do
    Organization.create!(name: "abc")
    organization = Organization.new(name: "abc")

    assert_not organization.valid?
    assert organization.errors.of_kind?(:name, :taken)
  end
end
