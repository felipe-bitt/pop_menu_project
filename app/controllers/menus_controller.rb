class MenusController < ApplicationRecord
  def index
    menus = Menu.all

    render json: menus
  end

  def show
    menu = Menu.find_(params[:id])

    render json: menu, include: :menu_items
  end
end