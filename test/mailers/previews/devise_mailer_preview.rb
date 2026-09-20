class DeviseMailerPreview < ActionMailer::Preview
  def reset_password_instructions
    user = User.new(email: "preview@example.com")

    Devise::Mailer.reset_password_instructions(user, "Preview-reset-token")
  end
end
