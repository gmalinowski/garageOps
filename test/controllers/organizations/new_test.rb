require "test_helper"

class OrganizationsNewTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

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
end
