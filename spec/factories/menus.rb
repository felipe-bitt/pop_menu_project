FactoryBot.define do
  factory :menu do
    name { Faker::Restaurant.type }
    association :restaurant
  end
end
