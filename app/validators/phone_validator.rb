class PhoneValidator < ActiveModel::EachValidator
  FORMAT = /\A\+?(?=(?:\D*\d){7})[\d ().-]+\z/
  DIGITS_RANGE = 7..15
  MAXIMUM_LENGTH = 32

  def validate_each(record, attribute, value)
    return if value.blank?

    digits_count = value.count("0-9")

    if value.length > MAXIMUM_LENGTH
      record.errors.add(attribute, :too_long, count: MAXIMUM_LENGTH)
    elsif !value.match?(FORMAT) || !DIGITS_RANGE.cover?(digits_count)
      record.errors.add(attribute, :invalid)
    end
  end
end
