require 'rails_helper'
require 'spec_helper'

RSpec.describe MenuItem, type: :model do
  it "is valid with a name and price" do
    menu_item = build(:menu_item, name: "Pizza", price: 12.99)

    expect(menu_item).to be_valid
  end

  it "is invalid without a name" do
    menu_item = build(:menu_item, name: nil)

    expect(menu_item).to_not be_valid
    expect(menu_item.errors[:name]).to include("can't be blank")
  end

  it "is invalid with a duplicate name" do
    create(:menu_item, name: "Pizza")
    duplicate_item = build(:menu_item, name: "Pizza")

    expect(duplicate_item).to_not be_valid
    expect(duplicate_item.errors[:name]).to include("has already been taken")
  end

  it "is valid with a positive price" do
    menu_item = build(:menu_item, price: 12.99)

    expect(menu_item).to be_valid
  end

  it "is invalid without a price" do
    menu_item = build(:menu_item, price: nil)

    expect(menu_item).to_not be_valid
    expect(menu_item.errors[:price]).to include("can't be blank")
  end

  it "is invalid with a negative price" do
    menu_item = build(:menu_item, price: -1)

    expect(menu_item).to_not be_valid
    expect(menu_item.errors[:price]).to include("must be greater than or equal to 0")
  end

  it "has and belongs to many menus" do
    menu_item = create(:menu_item)
    menu = create(:menu)
    menu_item.menus << menu

    expect(menu_item.menus).to include(menu)
  end

  it "is valid when associated with menus" do
    menu = create(:menu)
    menu_item = create(:menu_item, menus: [menu])

    expect(menu_item).to be_valid
    expect(menu_item.menus).to include(menu)
  end
end
