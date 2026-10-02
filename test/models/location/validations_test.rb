require "test_helper"

class LocationValidationsTest < ActiveSupport::TestCase
  setup do
    @org = create(:organization)
  end
  test "is valid with required attributes" do
    location = build(:location)
    assert location.valid?, location.errors.full_messages.to_sentence
  end

  test "name must be unique by organization" do
    org = create(:organization)
    create(:location, organization: org, name: "jeden333")
    location = build(:location, organization: org, name: "jeden333")
    assert location.invalid?
    assert location.errors.of_kind?(:name, :taken)
  end

  test "name can be duplicated outside organization" do
    org_1 = create(:organization)
    org_2 = create(:organization)

    create(:location, organization: org_1, name: "okej")
    location = build(:location, organization: org_2, name: "okej")

    assert location.valid?
  end

  test "name accepts between 3 and 120 characters" do
    assert build(:location, name: "a" * 3).valid?
    assert build(:location, name: "a" * 120).valid?
  end

  test "validates phone format" do
    location = build(:location, phone: "invalid phone")

    assert location.invalid?
    assert location.errors.of_kind?(:phone, :invalid)
  end

  test "validates email format" do
    location = build(:location, email: "invalid email")

    assert location.invalid?
    assert location.errors.of_kind?(:email, :invalid)
  end

  test "rejects unsuported country_code format" do
    location = build(:location, country_code: "ZZ")
    assert location.invalid?
    assert location.errors.of_kind?(:country_code, :inclusion)
  end

  test "rejects unsuported postal_code format" do
    location = build(:location, postal_code: "@@@")
    assert location.invalid?
    assert location.errors.of_kind?(:postal_code, :invalid)
  end

  test "accept valid postal_code" do
    location = build(:location, postal_code: "55-843")
    assert location.valid?
  end

  %i[name slug phone email address_line_1 postal_code city country_code].each do |field|
    test "requires #{field}" do
      location = build(:location, field => "")
      assert location.invalid?
      assert location.errors.of_kind?(field, :blank)
    end
  end

  {
    name: { min: 3, max: 120 },
    slug: { min: 3, max: 180 },
    description:  { min: nil, max: 5_000 },
    address_line_1: { min: nil, max: 255 },
    address_line_2: { min: nil, max: 255 },
    city: { min: nil, max: 255 },
    postal_code: { min: nil, max: 16 }
  }.each do |field, limits|
      limits => { min:, max: }

      test "#{field} max length is #{max} characters" do
        location = build(:location, organization: @org, field => "d" * (max + 1))
        assert location.invalid?
        assert location.errors.of_kind?(field, :too_long)
      end

      next unless min

      test "#{field} min length is #{min} characters" do
        location = build(:location, organization: @org, field => "d" * (min - 1))
        assert location.invalid?
        assert location.errors.of_kind?(field, :too_short)
      end
    end
end
