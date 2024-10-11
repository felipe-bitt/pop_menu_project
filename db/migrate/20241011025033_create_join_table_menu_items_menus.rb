class CreateJoinTableMenuItemsMenus < ActiveRecord::Migration[7.1]
  def change
    create_join_table :menu_items, :menus do |t|
      t.index :menu_item_id
      t.index :menu_id
    end
  end
end
