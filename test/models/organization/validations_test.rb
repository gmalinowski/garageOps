require "test_helper"

class OrganizationValidationsTest < ActiveSupport::TestCase
  test "is valid with all required fields" do
    org = build(:organization)
    assert org.valid?
  end

  test "requires name when it is nil" do
    org = build(:organization, name: nil)
    assert org.invalid?
    assert org.errors.of_kind?(:name, :blank)
  end

  test "name cannot be shorter than 2 characters" do
    org = build(:organization, name: "A")

    assert org.invalid?
    assert org.errors.of_kind?(:name, :too_short)
  end

  test "name accepts 2 characters" do
    org = build(:organization, name: "AB")

    assert org.valid?
  end

  [ :name, :slug ].each do |field|
    test "requires #{field}" do
      org = build(:organization, field => "")
      assert_not org.valid?
      assert org.errors.of_kind?(field, :blank)
    end
  end

  [ :name, :tax_id ].each do |field|
    test "requires #{field} to be unique" do
      value = "unique-vlaue"
      create(:organization, field => value)
      org = build(:organization, field => value)

      assert_not org.valid?
      assert org.errors.of_kind?(field, :taken)
    end
  end

  test "rejects unsupported countries" do
    org = build(:organization, country_code: "ZZ")
    assert org.invalid?
    assert org.errors.of_kind?(:country_code, :inclusion)
  end

  test "accepts empty country code" do
    org = build(:organization, country_code: "")
    assert org.valid?
  end

  test "rejects invalid email formats" do
    org = build(:organization, email: "superexmple")
    assert org.invalid?
    assert org.errors.of_kind?(:email, :invalid)
  end

  test "validates phone format" do
    organization = build(:organization, phone: "invalid phone")

    assert organization.invalid?
    assert organization.errors.of_kind?(:phone, :invalid)
  end

  test "rejects invalid website/url format" do
    org = build(:organization, website: "asfdsdjfoiwejrq")
    assert org.invalid?
    assert org.errors.of_kind?(:website, :invalid)
  end
  {
    name: 120,
    slug: 180,
    description: 5_000,
    email: 254,
    website: 3_000,
    address_line_1: 255,
    address_line_2: 255,
    city: 255,
    postal_code: 32,
    tax_id: 32,
    regon: 14
  }.each do |field, maximum|
    test "#{field} cannot be longer than #{maximum} characters" do
      organization = build(
        :organization,
        field => "a" * (maximum + 1)
      )

      assert organization.invalid?
      assert organization.errors.of_kind?(field, :too_long)
    end
  end

  %w[tax_id country_code description email website phone address_line_1 address_line_2 city postal_code regon].each do |field|
    test "empty #{field} is valid" do
      org = build(:organization)
      org[field] = ""
      assert org.valid?
    end
  end

  test "allows multiple organizations without tax id (unique + allow_nil)" do
    Organization.create!(name: "First workshop")
    org = Organization.new(name: "Second Workshop")
    assert org.valid?, org.errors.full_messages.to_sentence
  end
end
