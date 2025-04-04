class ModelsController < ApplicationController
  before_action :set_model, only: [:update]
  before_action :set_brand, only: [:create]

  def index
    models = Model.all
    models = models.greater_than_price(params[:greater]) if params[:greater].present?
    models = models.less_than_price(params[:lower]) if params[:lower].present?
    render json: models.select(:id, :name, :average_price)
  end

  def create

    model = @brand.models.build(model_params)
    if model.save
      render json: model, status: :created
    else
      render json: { error: model.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def brand
    models = @brand.models
    render json: models.select(:id, :name, :average_price)
  end

  def update
    if params[:model].key?(:name)
      return render json: { error: ["El parámetro 'name' no se puede actualizar."] }, status: :unprocessable_entity
    end
    if @model.update(update_params)
      render json: @model
    else
      render json: { error:@model.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def set_model
    @model = Model.find_by(id: params[:id])
    render json: { error: ['Modelo no encontrado'] }, status: :not_found unless @model
  end

  def set_brand
    @brand = Brand.find_by(id: params[:brand_id])
    render json: { error: ['Marca no encontrada'] }, status: :not_found unless @brand
  end

  def model_params
    params.require(:model).permit(:name, :average_price)
  end

  def update_params
    params.require(:model).permit(:average_price)
  end
end
