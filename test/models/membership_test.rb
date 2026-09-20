require "test_helper"

class MembershipTest < ActiveSupport::TestCase

  test "is valid with a user and an organization" do
    membership = Membership.new(
      user: users(:one),
      organization: organizations(:one)
    )

    assert membership.valid?
  end

  test "many users can join organization" do
    Membership.create!(user: users(:one), organization: organizations(:two))
    membership = Membership.new(
      user: users(:two),
      organization: organizations(:two)
    )

    assert membership.valid?
  end

  test "is not valid without a user" do
    membership = Membership.new(
      organization: organizations(:one),
    )
    assert membership.invalid?
    assert membership.errors.of_kind?(:user, :blank)
  end

  test "is not valid without a organization" do
    membership = Membership.new(
      user: users(:one),
    )
    assert membership.invalid?
  end

  test "status is active by default" do
    membership = Membership.create!(
      user: users(:one),
      organization: organizations(:one)
    )

    assert_equal "active", membership.status
  end

  test "status can be any of allowed statuses" do
    %w[active suspended].each do |status|
      membership = Membership.new(
        user: users(:one),
        organization: organizations(:one),
        status: status
      )

      assert membership.valid?
    end
  end

  test "is invalid when status is not in allowed statuses" do
    invalid_status = "unknown"
    membership = Membership.new(
      user: users(:one),
      organization: organizations(:one),
      status: invalid_status
    )

    assert_not Membership::STATUSES.include? invalid_status
    assert membership.invalid?
    assert membership.errors.of_kind?(:status, :inclusion)
  end

  test "does not allow a user to join the same organization twice" do
    Membership.create!(
      user: users(:one),
      organization: organizations(:one),
    )

    membership = Membership.new(
      user: users(:one),
      organization: organizations(:one),
    )

    assert membership.invalid?
    assert membership.errors.of_kind?(:user, :taken)
  end

  test "user can join many organizations" do
    Membership.create!(
      user: users(:one),
      organization: organizations(:one),
    )
    membership = Membership.new(
      user: users(:one),
      organization: organizations(:two),
    )
    assert membership.valid?
  end
end
