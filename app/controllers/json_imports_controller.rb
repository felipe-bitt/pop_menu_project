class JsonImportsController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [:create]

  class JsonImportError < StandardError; end 

  def create
    return render json: { error: 'No file was uploaded' }, status: :unprocessable_entity unless params[:file].present?

    begin
      file = params[:file].read
      json_data = JSON.parse(file)


      result = JsonImportService.new(json_data).process

      return render json: { message: 'File import failed', logs: result[:logs] }, status: :unprocessable_entity unless result[:success]

      render json: { message: 'File successfully imported', logs: result[:logs] }, status: :ok
    rescue JSON::ParserError
      render json: { error: 'Invalid JSON format' }, status: :unprocessable_entity
    rescue JsonImportError => e
      render json: { error: "An error occurred: #{e.message}" }, status: :internal_server_error
    end
  end
end