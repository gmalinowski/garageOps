FactoryBot.define do
  factory :permission do
    sequence(:key) { |n| "locations.permission_#{n}" }
    sequence(:name) { |n| "Location permission #{n}" }
    description { "Allows performing an operation." }
  end
end
