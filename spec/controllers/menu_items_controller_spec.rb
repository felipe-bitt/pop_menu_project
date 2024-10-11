require 'rails_helper'
require 'spec_helper'

RSpec.describe MenuItemsController, type: :controller do
  let(:restaurant) { create(:restaurant) }
  let(:menu) { create(:menu, restaurant: restaurant) }
  let(:menu_item) { create(:menu_item, menus: [menu]) }

  describe 'GET #index' do
    it "returns a list of menu items for the menu" do
      create_list(:menu_item, 3, menus: [menu])
      get :index, params: { menu_id: menu.id }
      
      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body).size).to eq(3)
    end
  end

  describe 'GET #show' do
    it 'returns a specific menu item' do
      get :show, params: { menu_id: menu.id, id: menu_item.id }

      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)['name']).to eq(menu_item.name)
    end

    it 'returns a 404 if menu item not found' do
      get :show, params: { menu_id: menu.id, id: 999 }

      expect(response).to have_http_status(:not_found)
      expect(JSON.parse(response.body)['error']).to eq('Menu item not found')
    end
  end

  describe 'POST #create' do
    it 'creates a new menu item' do
      menu_item_params = { name: 'New Item', price: 10.99, description: 'Delicious food' }

      post :create, params: { menu_id: menu.id, menu_item: menu_item_params }

      expect(response).to have_http_status(:created)
      expect(JSON.parse(response.body)['name']).to eq('New Item')
    end

    it 'returns errors when invalid data is provided' do
      invalid_params = { name: '', price: -1 }

      post :create, params: { menu_id: menu.id, menu_item: invalid_params }

      expect(response).to have_http_status(:unprocessable_entity)
      expect(JSON.parse(response.body)['errors']).to include("Name can't be blank", "Price must be greater than or equal to 0")
    end
  end

  describe 'PUT #update' do
    it 'updates an existing menu item' do
      updated_params = { name: 'Updated Item', price: 12.99, description: 'Even better food' }

      put :update, params: { menu_id: menu.id, id: menu_item.id, menu_item: updated_params }

      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)['name']).to eq('Updated Item')
    end

    it 'returns errors when invalid data is provided' do
      invalid_params = { name: '', price: -1 }

      put :update, params: { menu_id: menu.id, id: menu_item.id, menu_item: invalid_params }

      expect(response).to have_http_status(:unprocessable_entity)
      expect(JSON.parse(response.body)['errors']).to include("Name can't be blank", "Price must be greater than or equal to 0")
    end
  end

  describe 'DELETE #destroy' do
    it 'deletes the menu item' do
      delete :destroy, params: { menu_id: menu.id, id: menu_item.id }

      expect(response).to have_http_status(:no_content)
      expect { menu_item.reload }.to raise_error(ActiveRecord::RecordNotFound)
    end

    it 'returns a 404 if menu item not found' do
      delete :destroy, params: { menu_id: menu.id, id: 999 }

      expect(response).to have_http_status(:not_found)
      expect(JSON.parse(response.body)['error']).to eq('Menu item not found')
    end
  end
end
