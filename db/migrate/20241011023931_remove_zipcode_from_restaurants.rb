class RemoveZipcodeFromRestaurants < ActiveRecord::Migration[7.1]
  def change
    remove_column :restaurants, :zipcode, :string
  end
end
