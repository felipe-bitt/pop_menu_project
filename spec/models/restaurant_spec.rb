require 'rails_helper'
require 'spec_helper'

RSpec.describe Restaurant, type: :model do
  it "is valid with a name" do
    restaurant = build(:restaurant, name: "Sushi Place", address: "123 Sushi Street")

    expect(restaurant).to be_valid
  end

  it "is invalid without a name" do
    restaurant = build(:restaurant, name: nil)

    expect(restaurant).to_not be_valid
    expect(restaurant.errors[:name]).to include("can't be blank")
  end

  it "has many menus" do
    restaurant = create(:restaurant)
    menu1 = create(:menu, restaurant: restaurant)
    menu2 = create(:menu, restaurant: restaurant)

    expect(restaurant.menus).to include(menu1, menu2)
  end

  it "destroys associated menus when destroyed" do
    restaurant = create(:restaurant)
    menu = create(:menu, restaurant: restaurant)

    expect { restaurant.destroy }.to change { Menu.count }.by(-1)
  end
end
