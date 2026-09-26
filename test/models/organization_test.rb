require "test_helper"

class OrganizationTest < ActiveSupport::TestCase

  test "is valid with all required fields" do
    org = build(:organization)
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
end
