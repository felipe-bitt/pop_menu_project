FactoryBot.define do
  factory :menu_item do
    sequence(:name) { |n| "Item #{n}" }
    price { Faker::Commerce.price(range: 1.0..100.0) }
    description { Faker::Food.description }
  end
end
