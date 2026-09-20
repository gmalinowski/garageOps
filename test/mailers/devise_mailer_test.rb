require "test_helper"
class DeviseMailerTest < ActionMailer::TestCase
  test "reset_password_instructions include password reset link" do
    user = users(:one)
    token = "jfa89s923f"
    email = Devise::Mailer.reset_password_instructions(user, token)
    expected_url = Rails.application.routes.url_helpers.edit_user_password_url(
reset_password_token: token,
host: "example.com"
)

    assert_not_nil email.html_part, "Missing HTML version"
    assert_not_nil email.text_part, "Missing text version"

    html = Nokogiri::HTML.fragment(email.html_part.body.decoded)
    txt = email.text_part.body.decoded

    assert_equal [ user.email ], email.to
    assert_includes html.css("a").map { |link| link["href"] }, expected_url
    assert_includes txt, expected_url
  end
end
