require "test_helper"

class SessionsTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @user = User.create!(
      email: "test@example.com",
      password: "passwordpassword",
      password_confirmation: "passwordpassword"
    )
  end

  test "valid credentials open the protected landing page (dashboard)" do
    post user_session_path, params: {
      user: {
        email: @user.email,
        password: @user.password
      }
    }

    assert_redirected_to dashboard_path
  end

  test "invalid credentials show error message" do
    post user_session_path, params: {
      user: {
        email: @user.email,
        password: "password"
      }
    }
    assert_equal I18n.t("devise.failure.invalid", authentication_keys: "email"), flash[:alert]
  end
end
