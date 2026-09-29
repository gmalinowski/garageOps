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
end
