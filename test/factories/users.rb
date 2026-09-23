FactoryBot.define do
  factory :user do
    email { Faker::Internet.unique.email }
    password { "password1234" }
    password_confirmation { "password1234" }

    trait :with_organization do
      after(:create) do |user|
        org = create(:organization)
        create(:membership, user: user, organization: org, status: :active)
      end
    end
  end
end