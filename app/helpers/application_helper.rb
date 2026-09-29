module ApplicationHelper
  def field_error_aria(form, attribute, describedby: nil)
    invalid = form.object.errors[attribute].any?
    ids = [
      describedby,
      (form.field_id(attribute, :error) if invalid)
    ].compact_blank

    {
      invalid: invalid,
      describedby: ids.join(" ").presence
    }
  end

  def country_name(country_code)
    return if country_code.blank?

    country = ISO3166::Country[country_code]

    country&.translation(I18n.locale.to_s) ||
    country&.common_name ||
    country_code
  end
end
