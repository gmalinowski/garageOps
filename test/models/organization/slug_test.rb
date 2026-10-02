require "test_helper"

class OrganizationSlugTest < ActiveSupport::TestCase
  test "uses slug as URL parameter" do
    organization = create(:organization, slug: "my-workshop")

    assert_equal "my-workshop", organization.to_param
  end

  test "generates slug from name" do
    org = build(:organization, name: "My Workshop")
    org.valid?
    assert_equal "my-workshop", org.slug
  end

  test "generates unique slug on conflict" do
    create(:organization, slug: "my-workshop")
    org = build(:organization, name: "My Workshop")
    org.valid?
    assert org.slug.start_with?("my-workshop-")
    assert_not_equal "my-workshop", org.slug
  end

  test "does not update slug on name update" do
    organization = create(:organization, name: "my org One")
    assert_no_changes -> { organization.reload.slug } do
      organization.update!(name: "your org two")
    end
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
end
