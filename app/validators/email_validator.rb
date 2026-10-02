class EmailValidator < ActiveModel::EachValidator
  FORMAT = /\A
    [a-z0-9]+
    (?:[._%+\-][a-z0-9]+)*
    @
    [a-z0-9]+
    (?:[.-][a-z0-9]+)*
    \.[a-z]{2,}
  \z/ix
  MAXIMUM_LENGTH = 254

  def validate_each(record, attribute, value)
    return if value.nil?

    if value.length > MAXIMUM_LENGTH
      record.errors.add(attribute, :too_long, count: MAXIMUM_LENGTH)
    elsif !value.match(FORMAT)
      record.errors.add(attribute, :invalid)
    end
  end
end
