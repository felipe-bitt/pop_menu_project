require 'rails_helper'
require 'spec_helper'

RSpec.describe Menu, type: :model do
  it "is valid with a name" do
    menu = build(:menu, name: "Lunch Menu")

    expect(menu).to be_valid
  end

  it "is invalid without a name" do
    menu = build(:menu, name: nil)

    expect(menu).to_not be_valid
    expect(menu.errors[:name]).to include("can't be blank")
  end

  it "belongs to a restaurant" do
    restaurant = create(:restaurant)
    menu = create(:menu, restaurant: restaurant)

    expect(menu.restaurant).to eq(restaurant)
  end

  it "has and belongs to many menu_items" do
    menu = create(:menu)
    menu_item = create(:menu_item)
    menu.menu_items << menu_item

    expect(menu.menu_items).to include(menu_item)
  end

  it "can have multiple menu_items" do
    menu = create(:menu)
    menu_items = create_list(:menu_item, 3)
    menu.menu_items << menu_items

    expect(menu.menu_items.size).to eq(3)
    expect(menu.menu_items).to match_array(menu_items)
  end
end