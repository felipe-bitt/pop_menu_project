require 'rails_helper'
require 'spec_helper'

RSpec.describe RestaurantsController, type: :controller do
  let!(:restaurant) { create(:restaurant) }

  describe "GET #index" do
    it "returns a list of restaurants" do
      get :index
      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body).size).to eq(Restaurant.count)
    end
  end

  describe "GET #show" do
    it "returns the requested restaurant" do
      get :show, params: { id: restaurant.id }
      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)['id']).to eq(restaurant.id)
    end

    it "returns a 404 if restaurant not found" do
      get :show, params: { id: 999 }
      expect(response).to have_http_status(:not_found)
    end
  end

  describe "POST #create" do
    it "creates a new restaurant" do
      post :create, params: { restaurant: { name: 'New Restaurant', address: '123 Main St' } }
      expect(response).to have_http_status(:created)
    end

    it "returns errors if restaurant is invalid" do
      post :create, params: { restaurant: { name: '', address: '' } }
      expect(response).to have_http_status(:unprocessable_entity)
    end
  end

  describe "PUT #update" do
    it "updates the restaurant" do
      put :update, params: { id: restaurant.id, restaurant: { name: 'Updated Name' } }
      expect(response).to have_http_status(:ok)
      expect(restaurant.reload.name).to eq('Updated Name')
    end

    it "returns errors if update is invalid" do
      put :update, params: { id: restaurant.id, restaurant: { name: '' } }
      expect(response).to have_http_status(:unprocessable_entity)
    end
  end

  describe "DELETE #destroy" do
    it "deletes the restaurant" do
      expect { delete :destroy, params: { id: restaurant.id } }.to change(Restaurant, :count).by(-1)
      expect(response).to have_http_status(:no_content)
    end
  end
end
