class DataImportController < ApplicationController
  def index
  end

  def users
    return unless request.post?

    if params[:data_import].blank? || params[:data_import][:file].blank?
      flash.now[:alert] = "Arquivo ou empresa não selecionado."
      render :index and return
    end

    company_id = params[:data_import][:company_id].to_i

    Importers::CsvImporter.new(params[:data_import][:file].path, company_id).userImporter
    redirect_to data_import_path, notice: "Users imported successfully!"
  end
end
