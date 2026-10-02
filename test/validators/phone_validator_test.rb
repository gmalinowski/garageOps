require "test_helper"

class PhoneValidatorTest < ActiveSupport::TestCase
  class Validatable
    include ActiveModel::Model

    attr_accessor :phone

    validates :phone, phone: true, allow_blank: true
  end

  test "accepts supported phone formats" do
    [
      "+48 123 456 789",
      "+1 (555) 123-4567",
      "22 123 45 67",
      "123456789",
      "481234567890123"
    ].each do |phone|
      record = Validatable.new(phone:)

      assert record.valid?, "#{phone.inspect} should be valid"
    end
  end

  test "rejects unsupported phone formats" do
    [
      "call me",
      "123",
      "++48 123 456 789",
      "+48 ABC 456 789",
      "+4999834377783283"
    ].each do |phone|
      record = Validatable.new(phone:)

      assert record.invalid?,
             "#{phone.inspect} should be invalid"

      assert record.errors.of_kind?(:phone, :invalid)
    end
  end

  test "allows blank phone when configured" do
    record = Validatable.new(phone: "")

    assert record.valid?
  end
end
