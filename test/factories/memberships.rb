FactoryBot.define do
  factory :membership do
    user
    organization
    status { :active }
    title { Faker::Job.position }
  end
end