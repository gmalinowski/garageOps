require "test_helper"

class PermissionTest < ActiveSupport::TestCase
  REQUIRED_FIELDS = %w[key name]

  # VALIDATION
  test "requires all fields" do
    REQUIRED_FIELDS.each do |field|
         permission = build(:permission, field => nil)
         assert permission.invalid?
         assert permission.errors.of_kind?(field, :blank)
       end
  end

  test "validate all fields lenght" do
    {
      key: { min: 3, max: 128 },
      name: { min: 5, max: 256 },
      description: { min: nil, max: 1024 }
    }.each do |field, limits|
        limits => { min:, max: }

        permission = build(:permission, field => "d" * (max + 1))
        assert permission.invalid?
        assert permission.errors.of_kind?(field, :too_long)

        next unless min

        permission = build(:permission, field => "d" * (min - 1))
        assert permission.invalid?
        assert permission.errors.of_kind?(field, :too_short)
      end
  end

  test "key must be unique" do
    create(:permission, key: "key.edit")
    permission = build(:permission, key: "key.edit")
    assert permission.invalid?
    assert permission.errors.of_kind?(:key, :taken)
  end

  test "name must be unique" do
    create(:permission, name: "Test test name")
    permission = build(:permission, name: "Test test name")
    assert permission.invalid?
    assert permission.errors.of_kind?(:name, :taken)
  end

  # NORMALIZATION
  test "normalizes key" do
    permission = build(:permission, key: "  ACtion.teST  ")
    assert_equal "action.test", permission.key
  end

  test "strip name" do
    permission = build(:permission, name: " just Test   ")
    assert_equal "just Test", permission.name
  end

  test "strip description" do
    permission = build(:permission, description: "    Its a description      ")
    assert_equal "Its a description", permission.description
  end

  # ASSOCIATION
  test "returns memberships granted this permission" do
    permission = create(:permission)
    first_membership = create(:membership)
    second_membership = create(:membership)

    create(
      :membership_permission,
      permission:,
      membership: first_membership,
      organization: first_membership.organization,
      scope_type: :organization,
      location: nil
    )

    create(
      :membership_permission,
      permission:,
      membership: second_membership,
      organization: second_membership.organization,
      scope_type: :organization,
      location: nil
    )

    assert_equal(
      [ first_membership.id, second_membership.id ].sort,
      permission.memberships.pluck(:id).sort
    )
  end


  test "deleting permission removes its membership permissions" do
    membership_permission = create(:membership_permission)

    assert membership_permission.permission.present?

    assert_difference("MembershipPermission.count", -1) do
      membership_permission.permission.delete
    end

    assert_not MembershipPermission.exists?(membership_permission.id)
  end
end
