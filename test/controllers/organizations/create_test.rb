require "test_helper"

class OrganizationsCreateTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

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
