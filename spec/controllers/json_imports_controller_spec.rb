require 'rails_helper'
require 'spec_helper'

RSpec.describe JsonImportsController, type: :controller do
  describe 'POST #create' do
    let(:valid_file) do
      fixture_file_upload(Rails.root.join('spec', 'fixtures', 'files', 'restaurant_test_data.json'), 'application/json')
    end

    context 'when a valid file is uploaded' do
      it 'imports the file successfully' do
        post :create, params: { file: valid_file }

        expect(response).to have_http_status(:ok)
        json_response = JSON.parse(response.body)
        expect(json_response['message']).to eq('File successfully imported')
        expect(json_response['logs']).to be_present
      end
    end

    context 'when no file is uploaded' do
      it 'returns an error' do
        post :create, params: {}

        expect(response).to have_http_status(:unprocessable_entity)
        json_response = JSON.parse(response.body)
        expect(json_response['error']).to eq('No file was uploaded')
      end
    end

    context 'returns a validation error for blank name' do
      let(:invalid_file) { fixture_file_upload(Rails.root.join('spec', 'fixtures', 'files', 'invalid_data.json'), 'application/json') }

      it 'returns a JSON parsing error' do
        post :create, params: { file: invalid_file }

        json_response = JSON.parse(response.body)

        expect(json_response['logs']).to include("Error: Validation failed: Name can't be blank")
      end
    end
  end
end
