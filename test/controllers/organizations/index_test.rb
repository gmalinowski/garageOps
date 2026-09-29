require "test_helper"

class OrganizationsIndexTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  test "redirects unauthenticated user from organizations index" do
    get organizations_path

    assert_redirected_to new_user_session_path
  end

  test "lists organizations from policy scope with links to details" do
    user = create(:user)

    active_organization = create(:organization)
    suspended_organization = create(:organization)
    unrelated_organization = create(:organization)

    create(
      :membership,
      user:,
      organization: active_organization,
      status: :active
    )

    create(
      :membership,
      user:,
      organization: suspended_organization,
      status: :suspended
    )

    sign_in user
    get organizations_path

    assert_response :success

    assert_select "[data-testid=?]", "organizations-list" do
      assert_select "a[href=?]",
                    organization_path(active_organization),
                    text: /#{Regexp.escape(active_organization.name)}/

      assert_select "*", text: suspended_organization.name

      assert_select "[data-testid=?]", "organization-status", text: I18n.t("organizations.index.suspended")

      assert_select "*",
                    text: unrelated_organization.name,
                    count: 0
    end
  end

  test "shows empty state when user has no organizations" do
    sign_in create(:user)

    get organizations_path

    assert_response :success

    assert_select "[data-testid=?]", "organizations-empty-state"
    assert_select "a[href=?]", new_organization_path
  end
end
