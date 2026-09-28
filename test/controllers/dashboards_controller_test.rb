require "test_helper"

class DashboardsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  test "redirects unauthenticated user to sign_in" do
    get dashboard_path
    assert_redirected_to new_user_session_path
  end

  test "authenticated user can access dashboard" do
    sign_in create(:user)
    get dashboard_path
    assert_response :success
  end

  test "navbar lists only organizations the user belongs to" do
    user = create(:user)

    active_organization = create(:organization)
    suspended_organization = create(:organization)
    unrelated_organization = create(:organization)

    create(:membership, user:, organization: active_organization, status: :active)
    create(:membership, user:, organization: suspended_organization, status: :suspended)
    create(:membership, user: create(:user), organization: unrelated_organization, status: :active)

    sign_in user
    get dashboard_path

    assert_response :success

    assert_select "[data-testid=?]", "organization-switcher" do
      assert_select "*", text: active_organization.name
      assert_select "*", text: suspended_organization.name
      assert_select "*", text: unrelated_organization.name, count: 0
    end
  end
end
