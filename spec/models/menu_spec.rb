require 'rails_helper'
require 'spec_helper'

RSpec.describe Menu, type: :model do
  it "is valid with a name" do
    menu = create(:menu)

    expect(menu).to be_valid
  end

  it "is invalid without a name" do
    menu = build(:menu, name: nil)

    expect(menu).to_not be_valid
    expect(menu.errors[:name]).to include("can't be blank")
  end

  it "can have many menu items" do
    menu = create(:menu)
    menu_item1 = create(:menu_item, menu: menu)
    menu_item2 = create(:menu_item, menu: menu)

    expect(menu.menu_items).to include(menu_item1, menu_item2)
  end

  it "deletes associated menu items when the menu is destroyed" do
    menu = create(:menu)
    create(:menu_item, menu: menu)

    expect { menu.destroy }.to change { MenuItem.count }.by(-1)
  end
end