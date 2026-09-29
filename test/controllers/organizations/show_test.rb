require "test_helper"

class OrganizationsShowTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  test "shows organization when membership is active" do
    user = create(:user)
    organization = create(:organization)
    create(:membership, user:, organization:, status: :active)

    sign_in user
    get organization_path(organization)

    assert_response :success

    assert_select "[data-testid=?]", "organization-details" do
      assert_select "*", text: /#{Regexp.escape(organization.name)}/
      assert_select "*", text: /#{Regexp.escape(organization.description)}/
      assert_select "*", text: /#{Regexp.escape(organization.email)}/
      assert_select "*", text: /#{Regexp.escape(organization.phone)}/
      assert_select "*", text: /#{Regexp.escape(organization.address_line_1)}/
      assert_select "*", text: /#{Regexp.escape(organization.city)}/
      assert_select "*", text: /#{Regexp.escape(organization.postal_code)}/
      assert_select "*", text: /#{Regexp.escape(organization.tax_id)}/
      assert_select "*", text: /#{Regexp.escape(organization.regon)}/
    end
  end

  test "does not show organization the user does not belong to" do
    user = create(:user)
    organization = create(:organization)

    sign_in user
    get organization_path(organization)

    assert_response :not_found
  end

  test "does not show organization when membership is suspended" do
    user = create(:user)
    organization = create(:organization)
    create(:membership, user:, organization:, status: :suspended)

    sign_in user

    assert_raises(Pundit::NotAuthorizedError) do
      get organization_path(organization)
    end
  end

  test "redirects unauthenticated user from organization" do
    organization = create(:organization)

    get organization_path(organization)

    assert_redirected_to new_user_session_path
  end
end
