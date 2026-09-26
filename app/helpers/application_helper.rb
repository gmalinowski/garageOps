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
end
