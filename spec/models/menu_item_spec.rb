require 'rails_helper'
require 'spec_helper'

RSpec.describe MenuItem, type: :model do
  it "belongs to a menu" do
    menu = create(:menu)
    menu_item = create(:menu_item, menu: menu)

    expect(menu_item.menu).to eq(menu)
  end

  it "is valid with a name and price" do
    menu_item = create(:menu_item)

    expect(menu_item).to be_valid
  end

  it "is invalid without a name" do
    menu_item = build(:menu_item, name: nil)

    expect(menu_item).to_not be_valid
    expect(menu_item.errors[:name]).to include("can't be blank")
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
end
