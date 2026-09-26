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

  test "requires email" do
    user = build(:user, email: "")
    assert user.invalid?
    assert user.errors.of_kind?(:email, :blank)
  end

  test "rejects mismatched password confirmation" do
    user = build(:user, password: "kiueokdjfie234", password_confirmation: "ddddddddjjjjjjjjjjkljk")
    assert user.invalid?
    assert user.errors.of_kind?(:password_confirmation, :confirmation)
  end

  test "rejects passwords shorter than 12 characters" do
    password = "a" * 11
    user = build(:user,
                 password: password,
                 password_confirmation: password
    )

    assert user.invalid?
    assert user.errors.of_kind?(:password, :too_short)
  end

  test "accepts a 12-character password" do
    password = "a" * 12
    user = build(:user,
                 password: password,
                 password_confirmation: password
    )

    assert user.valid?, user.errors.full_messages.to_sentence
  end
end
