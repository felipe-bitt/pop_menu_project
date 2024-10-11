class JsonImportsController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [:create]

  def create
    if params[:file].present?
      begin
        file = params[:file].read
        json_data = JSON.parse(file)

        result = JsonImportService.new(json_data).process

        if result[:success]
          render json: { message: 'File successfully imported', logs: result[:logs] }, status: :ok
        else
          render json: { message: 'File import failed', logs: result[:logs] }, status: :unprocessable_entity
        end
      rescue JSON::ParserError
        render json: { error: 'Invalid JSON format' }, status: :unprocessable_entity
      rescue StandardError => e
        render json: { error: "An error occurred: #{e.message}" }, status: :internal_server_error
      end
    else
      render json: { error: 'No file was uploaded' }, status: :unprocessable_entity
    end
  end
end
