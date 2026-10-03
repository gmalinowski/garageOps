FactoryBot.define do
  factory :membership_permission do
    organization
    membership { association(:membership, organization:) }
    location { association(:location, organization:) }
    permission
    scope_type { "location" }
  end
end
