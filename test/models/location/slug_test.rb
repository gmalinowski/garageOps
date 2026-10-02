require "test_helper"

class LocationSlugTest < ActiveSupport::TestCase
  test "user slug as url parameter" do
    location = create(:location, slug: "jeden-dwa-trzy")
    assert_equal "jeden-dwa-trzy", location.to_param
  end

  test "slug must be unique scoped by organization" do
    organization = create(:organization)
    create(:location, organization:, slug: "test-test")
    location_2 = build(:location, organization:, slug: "test-test")
    assert location_2.invalid?
    assert location_2.errors.of_kind?(:slug, :taken)
  end

  test "slug can be duplicated outside same organization" do
    create(:location, organization: create(:organization), slug: "test-test")
    location = build(:location, organization: create(:organization), slug: "test-test")
    assert location.valid?
  end

  test "generates unique slug on conflict" do
    organization = create(:organization, name: "My Workshop")
    existing_location = create(
      :location,
      organization:,
      name: "Main Workshop",
      slug: nil
    )
    location = build(
      :location,
      organization:,
      name: "Main-Workshop",
      slug: nil
    )

    assert location.valid?, location.errors.full_messages.to_sentence
    assert location.slug.start_with?("main-workshop-")
    assert_not_equal existing_location.slug, location.slug
    assert location.save!, location.errors.full_messages.to_sentence
    assert location.reload.slug.start_with?("main-workshop-")
  end

  test "does not update slug on name update" do
    location = create(:location, name: "location One")
    assert_no_changes -> { location.reload.slug } do
      location.update!(name: "location two")
    end
  end

  test "slug should be normalized" do
    location = build(:location, slug: "   My-LOCAtion   ")

    assert_equal "my-location", location.slug
    assert location.valid?
  end

  test "generates slug from name when slug is nil" do
    location = build(:location, name: "My super location  ", slug: nil)
    location.valid?
    assert_equal "my-super-location", location.slug
  end

  test "slug can be provided" do
    location = build(:location, name: "one two", slug: "just-slug")
    assert location.valid?
    assert_equal "just-slug", location.slug
  end

  test "slug accepts letters, numbers and hyphens" do
    location = build(:location, slug: "one-2-three")
    assert location.valid?
  end

  test "slug rejects unsupported characters" do
    location = build(:location, slug: "one@-three two")
    assert location.invalid?
    assert location.errors.of_kind?(:slug, :invalid)
  end

  test "rejects a whitespace-only slug" do
    location = build(:location, slug: "     ")
    assert location.invalid?
    assert location.errors.of_kind?(:slug, :blank)
  end

  test "strip surronding whitespaced from slug" do
    location = build(:location, name: "Something different", slug: "  location  ")
    location.valid?
    assert_equal "location", location.slug
  end
end
