require 'rails_helper'
require 'spec_helper'

RSpec.describe MenusController, type: :controller do
  let!(:restaurant) { create(:restaurant) }
  let!(:menu) { create(:menu, restaurant: restaurant) }

  describe "GET #index" do
    it "returns a list of menus for the restaurant" do
      get :index, params: { restaurant_id: restaurant.id }
      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body).size).to eq(restaurant.menus.count)
    end
  end

  describe "GET #show" do
    it "returns the requested menu" do
      get :show, params: { restaurant_id: restaurant.id, id: menu.id }
      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)['id']).to eq(menu.id)
    end

    it "returns a 404 if menu not found" do
      get :show, params: { restaurant_id: restaurant.id, id: 999 }
      expect(response).to have_http_status(:not_found)
    end
  end

  describe "POST #create" do
    it "creates a new menu" do
      post :create, params: { restaurant_id: restaurant.id, menu: { name: 'New Menu' } }
      expect(response).to have_http_status(:created)
    end

    it "returns errors if menu is invalid" do
      post :create, params: { restaurant_id: restaurant.id, menu: { name: '' } }
      expect(response).to have_http_status(:unprocessable_entity)
    end
  end

  describe "PUT #update" do
    it "updates the menu" do
      put :update, params: { restaurant_id: restaurant.id, id: menu.id, menu: { name: 'Updated Menu' } }
      expect(response).to have_http_status(:ok)
      expect(menu.reload.name).to eq('Updated Menu')
    end

    it "returns errors if update is invalid" do
      put :update, params: { restaurant_id: restaurant.id, id: menu.id, menu: { name: '' } }
      expect(response).to have_http_status(:unprocessable_entity)
    end
  end

  describe "DELETE #destroy" do
    it "deletes the menu" do
      expect { delete :destroy, params: { restaurant_id: restaurant.id, id: menu.id } }.to change(Menu, :count).by(-1)
      expect(response).to have_http_status(:no_content)
    end
  end
end