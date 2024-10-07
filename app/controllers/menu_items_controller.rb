class MenuItemsController < ApplicationRecord
  before_action :set_menu

  def index
    menu_items = @menu.menu_items

    render json: menu_items
  end

  def show
    menu_item = @menu.menu_item.find(params[:id])

    render json: menu_item
  end

  private

  def set_menu
    @menu = Menu.find(params[:menu_id])
  end
end