class RestaurantsController < ApplicationController
  before_action :set_restaurant, only: [:show, :update, :destroy]

  def index
    restaurants = Restaurant.all

    render json: restaurants, status: :ok
  end

  def show
    render json: @restaurant, include: :menus, status: :ok
  end

  def create
    restaurant = Restaurant.new(restaurant_params)

    if restaurant.save
      render json: restaurant, status: :created
    else
      render json: { errors: restaurant.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    if @restaurant.update(restaurant_params)
      render json: @restaurant, status: :ok
    else
      render json: { errors: @restaurant.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    @restaurant.destroy

    head :no_content
  end

  private

  def set_restaurant
    @restaurant = Restaurant.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render json: { error: 'Restaurant not found' }, status: :not_found
  end

  def restaurant_params
    params.require(:restaurant).permit(:name, :address, :phone)
  end
end