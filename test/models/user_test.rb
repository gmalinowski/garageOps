require "test_helper"

class UserTest < ActiveSupport::TestCase
  test "returns only organizations the user belongs to" do
    user = create(:user)
    org_1 = create(:organization)
    org_2 = create(:organization)
    org_3 = create(:organization)
    create(:membership, user: user, organization: org_1)
    create(:membership, user: user, organization: org_2)

    assert_not_equal user.organizations.size, Organization.all.size
    assert_equal [ org_1.id, org_2.id ].sort, user.organizations.pluck(:id).sort
  end

  test "cannot be destroyed while memberships exist" do
    user = create(:user, :with_organization)
    membership = user.memberships.first

    assert_equal false, user.destroy

    assert User.exists?(user.id)
    assert Membership.exists?(membership.id)
    assert user.errors[:base].any?
  end

end
