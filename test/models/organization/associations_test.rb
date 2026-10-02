require "test_helper"

class OrganizationAssociationsTest < ActiveSupport::TestCase
  test "returns only users the organization has" do
    org = create(:organization)
    user_1 = create(:user)
    user_2 = create(:user)
    user_3 = create(:user)
    create(:membership, user: user_1, organization: org, status: :active)
    create(:membership, user: user_2, organization: org, status: :active)
    create(:membership, user: user_3, organization: create(:organization), status: :active)

    assert_equal 3, User.all.size
    assert_equal [ user_1.id, user_2.id ], org.users.pluck(:id).sort
  end

  test "cannot be destroyed while memberships exist" do
    org = create(:organization)
    create(:membership, user: create(:user), organization: org, status: :active)

    assert_equal false, org.destroy
    assert Organization.exists?(org.id)
    assert org.errors[:base].any?
  end

  test "returns only locations the organization has" do
    org = create(:organization)
    l1 = create(:location, organization: org)
    l2 = create(:location, organization: org)
    create(:location, organization: create(:organization))

    assert_equal 3, Location.all.size
    assert_equal [ l1.id, l2.id ], org.locations.pluck(:id).sort
  end

  test "cannot be destroyed while locations exist" do
    org = create(:organization)
    l1 = create(:location, organization: org)

    assert_equal false, org.destroy
    assert Organization.exists?(org.id)
    assert org.errors[:base].any?
  end

  test "can be destroyed" do
    org = create(:organization)
    l1 = create(:location, organization: org)

    l1.destroy!
    org.destroy!

    assert_not Organization.exists?(org.id)
  end
end
