FactoryBot.define do
  factory :location do
    organization
    name { Faker::Name.name }
    slug { name&.parameterize }
    phone { Faker::PhoneNumber.phone_number }
    email { Faker::Internet.email }
    address_line_1 { Faker::Address.street_address }
    address_line_2 { Faker::Address.secondary_address }
    city { Faker::Address.city }
    postal_code { Faker::Address.postcode }
    country_code { "PL" }
  end
end
