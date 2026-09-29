require "test_helper"

class RegistrationTest < ActionDispatch::IntegrationTest
  test "creates an account without an organization" do
    assert_difference "User.count", 1 do
      assert_no_difference [ "Organization.count", "Membership.count" ] do
        post user_registration_path, params: {
          user: {
            email: "new@example.com",
            password: "password1234",
            password_confirmation: "password1234"
          }
        }
      end
    end
  end

  test "account is unconfirmed by default" do
    assert_difference "User.count", 1 do
      post user_registration_path, params: {
        user: {
          email: "asia@example.com",
          password: "password1234",
          password_confirmation: "password1234"
        }
      }
    end

    assert_not User.find_by!(email: "asia@example.com").confirmed?
    assert_emails 1
    assert_redirected_to root_path
  end

  test "renders user errors without creating any records" do
    assert_no_difference [ "User.count", "Organization.count", "Membership.count" ] do
      post user_registration_path, params: {
        user: {
          email: "user@example.com",
          password: "passwordpassword12#",
          password_confirmation: "aaaaaaaaaaaabbbbbbbbbbbb"
        }
      }
    end

    assert_response :unprocessable_content
    assert_dom "[data-error-for='user[password_confirmation]']"
  end

  test "sign up form requires account fields without organization fields" do
    get new_user_registration_path
    assert_response :success
    assert_dom "form[action=?]", user_registration_path do
      assert_dom "[name^='organization[']", count: 0

      %w[
        user[email]
        user[password]
        user[password_confirmation]
      ].each do |field|
        assert_dom "[name=?][required]", field
      end
    end
  end
end
