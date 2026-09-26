require "test_helper"

class MembershipTest < ActiveSupport::TestCase
  test "many users can join organization" do
    organization = create(:organization)
    user_1 = create(:user)
    user_2 = create(:user)
    user_3 = create(:user)

    create(:membership, user: user_1, organization: organization)
    create(:membership, user: user_2, organization: organization)
    create(:membership, user: user_3, organization: organization)

    assert_equal 3, organization.memberships.count
    assert_equal 3, organization.users.count
    assert_equal(
      [ user_1.id, user_2.id, user_3.id ].sort,
      organization.users.pluck(:id).sort
    )
  end

  test "user cannot join same organization twice" do
    user = create(:user)
    organization = create(:organization)
    create(:membership, user: user, organization: organization)

    membership = build(:membership, user: user, organization: organization)
    assert_not membership.valid?
    assert membership.errors.of_kind?(:user, :taken)
  end

  test "user can join many organizations" do
    user = create(:user)
    org1 = create(:organization)
    org2 = create(:organization)

    create(:membership, user: user, organization: org1)
    create(:membership, user: user, organization: org2)

    assert_equal 2, user.memberships.count
    assert_equal 2, user.organizations.count
  end


  test "is valid" do
    membership = build(:membership)
    assert membership.valid?
  end

  test "is not valid without a user" do
    membership = build(:membership, user: nil)
    assert membership.invalid?
    assert membership.errors.of_kind?(:user, :blank)
  end

  test "is not valid without an organization" do
    membership = build(:membership, organization: nil)
    assert membership.invalid?
    assert membership.errors.of_kind?(:organization, :blank)
  end

  test "status is active by default" do
    membership = create(:membership)
    assert_equal "active", membership.status
  end

  test "status can be any of allowed statuses" do
    %w[active suspended].each do |status|
      membership = build(:membership, status: status)
      assert membership.valid?
    end
  end

  test "is invalid when status is not in allowed statuses" do
    invalid_status = "unknown"
    membership = build(:membership, status: invalid_status)
    assert_not Membership::STATUSES.include?(invalid_status)
    assert membership.invalid?
    assert membership.errors.of_kind?(:status, :inclusion)
  end
end
