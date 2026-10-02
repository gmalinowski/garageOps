require "test_helper"

class EmailValidatorTest < ActiveSupport::TestCase
  class Validatable
    include ActiveModel::Model

    attr_accessor :email

    validates :email, email: true, allow_nil: true
  end

  VALID_EMAILS = %w[
    user@example.com
    user.name@example.com
    user-name@example.com
    user_name@example.com
    user+tag@example.com
    user@sub.example.com
    USER@EXAMPLE.COM
  ]
  INVALID_EMAILS = [
    "superexample",
    "user",
    "@example.com",
    "user@",
    "user@@example.com",
    "user example@example.com",
    ".user@example.com",
    "user.@example.com",
    "user..name@example.com",
    "user@example..com",
    "user@-example.com",
    "user@example-.com"
  ]

  test "accepts supported email formats" do
    VALID_EMAILS.each do |email|
      record = Validatable.new(email: email)
      assert record.valid?, "#{email.inspect} should be valid"
    end
  end

  test "rejects unsupported email formats" do
    INVALID_EMAILS.each do |email|
      record = Validatable.new(email: email)
      assert record.invalid?, "#{email.inspect} should be invalid"
      assert record.errors.of_kind?(:email, :invalid)
    end
  end

  test "allows nil email when configured" do
    record = Validatable.new(email: nil)
    assert record.valid?
  end

  test "doesnot allow blank email" do
    record = Validatable.new(email: "")
    assert record.invalid?
  end
end
