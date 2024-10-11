class JsonImportService
  attr_reader :json_data, :logs

  def initialize(json_data)
    @json_data = json_data
    @logs = []
  end

  def process
    ActiveRecord::Base.transaction do
      @json_data['restaurants'].each do |restaurant_data|
        restaurant = Restaurant.find_or_create_by!(name: restaurant_data['name'])

        restaurant_data['menus'].each do |menu_data|
          menu = restaurant.menus.find_or_create_by!(name: menu_data['name'])

          menu_items_data = menu_data['menu_items'] || menu_data['dishes']
          menu_items_data.each do |item_data|
            menu_item = MenuItem.find_or_initialize_by(name: item_data['name'])

            if menu_item.new_record?
              menu_item.price = item_data['price']
              menu_item.save!
              logs << "Imported menu item: #{menu_item.name} for menu: #{menu.name} in restaurant: #{restaurant.name}"
            else
              logs << "Linked existing menu item: #{menu_item.name} for menu: #{menu.name} in restaurant: #{restaurant.name}"
            end

            menu.menu_items << menu_item unless menu.menu_items.include?(menu_item)
          end
        end
      end
    end

    { success: true, logs: @logs }
  rescue ActiveRecord::RecordInvalid => e
    @logs << "Error: #{e.message}"
    { success: false, logs: @logs }
  end
end