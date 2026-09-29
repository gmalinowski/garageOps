require "test_helper"

class DashboardPolicyTest < ActiveSupport::TestCase
  test "allows user to view dashboard" do
    user = create(:user)

    policy = DashboardPolicy.new(user, :dashboard)

    assert policy.show?
  end

  test "prevents missing user from viewing dashboard" do
    policy = DashboardPolicy.new(nil, :dashboard)
    assert_not policy.show?
  end
end
