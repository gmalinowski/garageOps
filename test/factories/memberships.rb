FactoryBot.define do
  factory :membership do
    user
    organization
    title { Faker::Job.position }
  end
end
