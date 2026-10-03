require "test_helper"

class MembershipPermissionTest < ActiveSupport::TestCase
  # VALIDATION
  test "rejects unsupported scope types" do
    [ nil, "test", :pomidor ].each do |type|
      mp = build(:membership_permission, scope_type: type)
      assert mp.invalid?
      assert mp.errors.of_kind?(:scope_type, :inclusion)
    end
  end


  test "location cannot be null if scope_type is location" do
    mp = build(:membership_permission, scope_type: "location", location: nil)
    assert mp.invalid?
    assert mp.errors.of_kind?(:location, :required_for_location_scope)
  end

  test "location must be null if scope_type is organization" do
    location = create(:location)
    mp = build(:membership_permission, scope_type: "organization", location:)
    assert mp.invalid?
    assert mp.errors.of_kind?(:location, :must_be_blank_for_organization_scope)
  end

  # ASSOCIATION

  test "requires membership" do
    mp = build(:membership_permission, membership: nil)
    assert mp.invalid?
    assert mp.errors.of_kind?(:membership, :blank)
  end

  test "requires permission" do
    mp = build(:membership_permission, permission: nil)
    assert mp.invalid?
    assert mp.errors.of_kind?(:permission, :blank)
  end

  test "is valid when membership and location belong to the same organizaiton" do
    organization = create(:organization)
    membership = create(:membership, organization:)
    location = create(:location, organization:)

    membership_permission = build(
      :membership_permission,
      organization:,
      membership:,
      location:,
      scope_type: :location
    )

    assert membership_permission.valid?, membership_permission.errors.full_messages.to_sentence
  end

  test "requires location to belong to the same organization" do
    organization = create(:organization)
    organization_other = create(:organization)
    location = create(:location, organization: organization_other)

    membership_permission = build(
      :membership_permission,
      organization:,
      location:,
      scope_type: :location
    )

    assert membership_permission.invalid?, membership_permission.errors.full_messages.to_sentence
    assert membership_permission.errors.of_kind?(:location, :organization_mismatch)
  end

  test "sets organization from membership" do
    membership = create(:membership)
    membership_permission = build(
      :membership_permission,
      membership:,
      organization: nil
    )

    membership_permission.valid?

    assert_equal(membership.organization_id, membership_permission.organization_id)
  end

  test "derives organization from membership" do
    membership = create(:membership)
    different_organization = create(:organization)

    membership_permission = build(
      :membership_permission,
      membership:,
      organization: different_organization
    )

    membership_permission.valid?
    assert_equal membership.organization, membership_permission.organization
  end
end
