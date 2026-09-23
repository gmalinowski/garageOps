FactoryBot.define do
  factory :organization do
    name { Faker::Company.unique.name }
    slug { name.parameterize }
    description { Faker::Company.catch_phrase }

    address_line_1 { Faker::Address.street_address }
    address_line_2 { Faker::Address.secondary_address }
    city { Faker::Address.city }
    postal_code { Faker::Address.postcode }
    country_code { "PL" }

    phone { Faker::PhoneNumber.phone_number }
    email { Faker::Internet.unique.email }
    website { Faker::Internet.url }

    tax_id { Faker::Number.unique.number(digits: 10) }
    regon { Faker::Number.unique.number(digits: 9) }
    active { true }

    trait :with_user do |num = 1|
      after(:create) do |org|
        user = create(:user)
        num.times do
          create(:membership, user: user, organization: org, status: :active)
        end
      end
    end
  end
end