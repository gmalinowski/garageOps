require "test_helper"

class UserTest < ActiveSupport::TestCase

  test "returns only organizations the user belongs to" do
    user = users(:no_organization_1)
    org_1 = organizations(:no_members_1)
    org_2 = organizations(:no_members_2)
    Membership.create!(user: user, organization: org_1)
    Membership.create!(user: user, organization: org_2)
    Membership.create!(user: users(:no_organization_2), organization: organizations(:no_members_3))


    assert_not_equal user.organizations.size, Organization.all.size
    assert_equal [org_1.id, org_2.id].sort, user.organizations.pluck(:id).sort
  end

  test "cannot be destroyed while memberships exist" do
    user = users(:with_one_org)
    membership = user.memberships.first

    assert_equal false, user.destroy

    assert User.exists?(user.id)
    assert Membership.exists?(membership&.id)
    assert user.errors[:base].any?
  end

end
