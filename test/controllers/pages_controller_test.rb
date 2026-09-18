require "test_helper"

class PagesControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  test "access home page" do
    get root_path
    assert_response :success
  end

  test "home shows sign in link to guests" do
    get root_path

    assert_select "nav a[href=?]", new_user_session_path, count: 1
  end

  test "authenticated user sees dashboard link" do
    sign_in users(:one)
    get root_path
    assert_select "nav a[href=?]", dashboard_path, count: 1
    assert_select "nav a[href=?]", new_user_session_path, count: 0
  end
end
