require "test_helper"

class Settings::ProfilesControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  test "redirects unauthenticated user to sign in" do
    get edit_settings_profile_path

    assert_redirected_to new_user_session_path
  end

  test "authenticated user can access profile edit page" do
    user = create(:user)
    sign_in user
    get edit_settings_profile_path
    assert_response :success
  end
end
