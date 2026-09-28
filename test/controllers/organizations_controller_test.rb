require "test_helper"
require "minitest/mock"

class OrganizationsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  test "lists only organizations from policy scope" do
    user = create(:user)

    accessible_organization = create(:organization)
    create(
      :membership,
      user:,
      organization: accessible_organization,
      status: "active"
    )

    inaccessible_organization = create(:organization)

    sign_in user
    get organizations_path

    assert_response :success
    assert_select "li", text: accessible_organization.name
    assert_select "li", text: inaccessible_organization.name, count: 0
  end

  test "unauthenticated user can not open new organization form" do
    get new_organization_path

    assert_redirected_to new_user_session_path
  end

  test "authenticated user can open new organization form" do
    sign_in create(:user)

    get new_organization_path

    assert_response :success

    assert_dom "form[action=?]", organizations_path do
      assert_dom "input[name='organization[name]'][required]"
      %w[
        name
        description
        email
        phone
        website
        tax_id
        address_line_1
        address_line_2
        postal_code
        city
        country_code
      ].each do |attribute|
        assert_dom "[name=?]", "organization[#{attribute}]"
      end
    end
  end

  test "creates organization and membership with valid params" do
    user = create(:user)
    sign_in user
    attributes = attributes_for(:organization)

    assert_difference([ "Organization.count", "Membership.count" ], 1) do
      post organizations_path, params: {
        organization: attributes
      }
    end

    organization = Organization.order(:created_at).last

    assert_equal attributes[:name], organization.name
    assert_equal attributes[:email], organization.email
    assert_equal attributes[:country_code], organization.country_code

    assert organization.users.include?(user)
    assert_redirected_to dashboard_path
    assert_equal I18n.t("organizations.create.success"), flash[:notice]
  end

  test "rolls back organization when membership creation fails" do
    sign_in create(:user)

    failure = ->(**) { raise "membership creation failed" }

    Membership.stub(:create!, failure) do
      assert_no_difference([ "Organization.count", "Membership.count" ]) do
        assert_raises(RuntimeError) do
          post organizations_path, params: {
            organization: attributes_for(:organization)
          }
        end
      end
    end
  end

  test "does not create organization with invalid params" do
    sign_in create(:user)

    assert_no_difference("Organization.count") do
      post organizations_path, params: {
        organization: attributes_for(:organization, name: "")
      }
    end

    assert_response :unprocessable_entity
  end

  test "unauthenticated user cannot create organization" do
    assert_no_difference([ "Organization.count", "Membership.count" ]) do
      post organizations_path, params: {
        organization: attributes_for(:organization)
      }
    end

    assert_redirected_to new_user_session_path
  end
end
