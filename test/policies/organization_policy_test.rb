require "test_helper"

class OrganizationPolicyTest < ActiveSupport::TestCase
  setup do
    @user = create(:user)
    @org = create(:organization)
  end

  test "scope returns only organizations the user belongs to" do
    accessible_org = create(:organization)
    create(:membership, user: @user, organization: accessible_org, status: "active")

    inaccessible_org = create(:organization)

    resolved = OrganizationPolicy::Scope.new(@user, Organization.all).resolve

    assert_includes resolved, accessible_org
    assert_not_includes resolved, inaccessible_org
  end

  test "scope includes organizations with suspended membership" do
    organization = create(:organization)
    create(
      :membership,
      user: @user,
      organization:,
      status: :suspended
    )

    resolved = OrganizationPolicy::Scope
      .new(@user, Organization.all)
      .resolve

    assert_includes resolved, organization
  end

  test "allows active member to view organization" do
    create(:membership, user: @user, organization: @org, status: "active")
    assert OrganizationPolicy.new(@user, @org).show?
  end

  test "prevents suspended member from viewing organization" do
    create(:membership, user: @user, organization: @org, status: "suspended")
    assert_not OrganizationPolicy.new(@user, @org).show?
  end

  test "prevents non-member from viewing organization" do
    assert_not OrganizationPolicy.new(@user, @org).show?
  end

  test "allows user to create organization" do
    policy = OrganizationPolicy.new(@user, Organization.new)

    assert policy.create?
    assert policy.new?
  end

  # def test_update
  # end

  # def test_destroy
  # end
end
