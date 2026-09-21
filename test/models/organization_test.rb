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

  test "returns only users the organization has" do
    organization = organizations(:no_members_1)
    user_1 = users(:no_organization_1)
    user_2 = users(:no_organization_2)

    Membership.create!(user: user_1, organization: organization)
    Membership.create!(user: user_2, organization: organization)
    Membership.create!(
      user: users(:no_organization_3),
      organization: organizations(:no_members_2)
    )

    assert_equal organizations(:no_members_2).users.size, 1
    assert_equal(
      [user_1.id, user_2.id].sort,
      organization.users.pluck(:id).sort
    )
  end

  test "cannot be destroyed while memberships exist" do
    organization = organizations(:two_members)
    membership = organization.memberships.first

    assert_equal false, organization.destroy

    assert Organization.exists?(organization.id)
    assert Membership.exists?(membership&.id)
    assert organization.errors[:base].any?
  end

end
