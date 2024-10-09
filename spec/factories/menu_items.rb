FactoryBot.define do
  factory :menu_item do
    name { Faker::Food.dish }
    price { Faker::Commerce.price(range: 1.0..300.0) }
    association :menu
  end
end