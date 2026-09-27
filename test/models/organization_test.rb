require "test_helper"

class OrganizationTest < ActiveSupport::TestCase
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

  test "allows multiple organizations without tax id" do
    Organization.create!(name: "First workshop")
    org = Organization.new(name: "Second Workshop")
    assert org.valid?, org.errors.full_messages.to_sentence
  end

  test "stores blank tax ids as nil for multiple organizations" do
    first = Organization.create!(name: "First blank tax id", tax_id: "")
    second = Organization.create!(name: "Second blank tax id", tax_id: "   ")

    assert_nil first.reload.tax_id
    assert_nil second.reload.tax_id
  end


  test "accepts empty country code" do
    org = build(:organization, country_code: "")
    assert org.valid?
  end

  test "rejects unsupported countries" do
    org = build(:organization, country_code: "ZZ")
    assert org.invalid?
    assert org.errors.of_kind?(:country_code, :inclusion)
  end

  test "returns only users the organization has" do
    org = create(:organization)
    user_1 = create(:user)
    user_2 = create(:user)
    user_3 = create(:user)
    create(:membership, user: user_1, organization: org, status: :active)
    create(:membership, user: user_2, organization: org, status: :active)
    create(:membership, user: user_3, organization: create(:organization), status: :active)

    assert_equal 3, User.all.size
    assert_equal [ user_1.id, user_2.id ], org.users.pluck(:id).sort
  end

  test "cannot be destroyed while memberships exist" do
    org = create(:organization)
    create(:membership, user: create(:user), organization: org, status: :active)

    assert_equal false, org.destroy
    assert Organization.exists?(org.id)
    assert org.errors[:base].any?
  end

  test "generates slug from name" do
    org = build(:organization, name: "My Workshop")
    org.valid?
    assert_equal "my-workshop", org.slug
  end

  test "generates unique slug on conflict" do
    existing = create(:organization, slug: "my-workshop")
    org = build(:organization, name: "My Workshop")
    org.valid?
    assert org.slug.start_with?("my-workshop-")
    assert_not_equal "my-workshop", org.slug
  end

  test "slug can be provided" do
    org = create(:organization, name: "www1", slug: "to-slug-23")
    assert_equal "to-slug-23", org.slug
  end

  test "slug accepts letter, numbers and hyphens" do
    org = build(:organization, slug: "one-two-234")
    assert org.valid?
  end

  test "slug rejects unsupported characters" do
    org = build(:organization, slug: "Garage ops")
    assert org.invalid?
    assert org.errors.of_kind?(:slug, :invalid)
  end

test "strips surrounding whitespace from slug" do
  organization = build(
    :organization,
    slug: "  my-workshop  "
  )

  assert_equal "my-workshop", organization.slug
  assert organization.valid?
end

test "rejects a whitespace-only slug" do
  organization = build(:organization, slug: "   ")

  assert organization.invalid?
  assert organization.errors.of_kind?(:slug, :blank)
end

  test "rejects invalid email formats" do
    org = build(:organization, email: "superexmple")
    assert org.invalid?
    assert org.errors.of_kind?(:email, :invalid)
  end

  test "normalizes email" do
    org = build(:organization, email: "  CONTact@eXAmple.com ")
    org.valid?
    assert_equal "contact@example.com", org.email
  end

  test "normalizes country_code" do
    org = build(:organization, country_code: "  pL ")
    org.valid?
    assert_equal "PL", org.country_code
  end

  test "normalizes tax_id" do
    org = build(:organization, tax_id: " DK99999999   ")
    org.valid?
    assert_equal "DK99999999", org.tax_id
  end

  test "squishes name field" do
    org = build(:organization, name: "My    work  shop  ")
    org.valid?
    assert_equal "My work shop", org.name
  end

  %w[email country_code tax_id description website phone address_line_1 address_line_2 city postal_code regon].each do |field|
    test "strips #{field}" do
      org = build(:organization)
      org[field] = "  test  "
      assert_equal "test", org[field].downcase
    end

    test "normalizes blank #{field} to nil" do
      org = build(:organization)
      org[field] = "    "
      org.valid?
      assert_nil org[field]
    end
  end


  test "accepts common phone number formats" do
  [
    "+48 123 456 789",
    "+1 (555) 123-4567",
    "22 123 45 67",
    "123456789"
  ].each do |phone|
    organization = build(:organization, phone: phone)

    assert organization.valid?,
           "#{phone.inspect} should be valid"
  end
end

test "rejects invalid phone number format" do
  [
    "call me",
    "123",
    "++48 123 456 789",
    "+48 ABC 456 789"
  ].each do |phone|
    organization = build(:organization, phone: phone)

    assert organization.invalid?
    assert organization.errors.of_kind?(:phone, :invalid)
  end
end

  test "rejects invalid website/url format" do
    org = build(:organization, website: "asfdsdjfoiwejrq")
    assert org.invalid?
    assert org.errors.of_kind?(:website, :invalid)
  end
{
  phone: 32,
  name: 120,
  slug: 180,
  description: 3_000,
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
end
