require "test_helper"

class ProfilePolicyTest < ActiveSupport::TestCase
  test "allows authenticated user to edti profile" do
    assert ProfilePolicy.new(create(:user), :profile).edit?
  end

  test "denies unauthenticated user" do
    assert_not ProfilePolicy.new(nil, :profile).edit?
  end
end
