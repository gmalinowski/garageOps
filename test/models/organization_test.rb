require "test_helper"

class OrganizationTest < ActiveSupport::TestCase

  test "is valid with all required fields" do
    org = build(:organization)
    assert org.valid?
  end

  [:name, :slug, :address_line_1, :postal_code, :city, :country_code, :phone, :email, :tax_id].each do |field|
    test "requires #{field}" do
      org = build(:organization, field => "")
      assert_not org.valid?
      assert org.errors.of_kind?(field, :blank)
    end
  end

  [:name, :slug, :tax_id].each do |field|
    test "requires #{field} to be unique" do
      value = "unique-vlaue"
      create(:organization, field => value)
      org = build(:organization, field => value)

      assert_not org.valid?
      assert org.errors.of_kind?(field, :taken)
    end
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
    assert_equal [user_1.id, user_2.id], org.users.pluck(:id).sort
  end

  test "cannot be destroyed while memberships exist" do
    org = create(:organization)
    create(:membership, user: create(:user), organization: org, status: :active)

    assert_equal false, org.destroy
    assert Organization.exists?(org.id)
    assert org.errors[:base].any?
  end

end
