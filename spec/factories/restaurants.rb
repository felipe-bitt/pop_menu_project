FactoryBot.define do
  factory :restaurant do
    name { Faker::Restaurant.name }
    address { Faker::Address.full_address }
    phone { Faker::PhoneNumber.cell_phone }
  end
end
