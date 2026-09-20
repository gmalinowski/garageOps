require "test_helper"

class PasswordRecoveryTest < ActionDispatch::IntegrationTest
  include ActionMailer::TestHelper

  setup do
    @user = users(:one)
    @old_password = "OldPassword123!"
    @new_password = "NewPassword123!"
    @user.update!(
      password: @old_password,
      password_confirmation: @old_password,
    )
  end

  test "user can request password reset instructions" do
    assert_emails 1 do
      post user_password_path, params: {
        user: { email: @user.email }
      }
    end

    assert_redirected_to new_user_session_path

    email = ActionMailer::Base.deliveries.last
    assert_equal [ @user.email ], email.to
  end

  test "user can reset password with valid token" do
    token = @user.send_reset_password_instructions

    patch user_password_path, params: {
      user: {
        reset_password_token: token,
        password: @new_password,
        password_confirmation: @new_password
      }
    }

    assert_response :redirect

    @user.reload
    assert @user.valid_password?(@new_password)
    assert_not @user.valid_password?(@old_password)
    assert_nil @user.reset_password_token
  end

  test "user can NOT reset password with invalid token" do
    patch user_password_path, params: {
      user: {
        reset_password_token: "invalid",
        password: @new_password,
        password_confirmation: @new_password
      }
    }

    assert_response :unprocessable_entity
    assert @user.valid_password?(@old_password)
    assert_not @user.valid_password?(@new_password)
  end
end
