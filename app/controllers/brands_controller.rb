class BrandsController < ApplicationController
  before_action :set_brand, only: [:show, :models]

  def index
    brands = Brand.includes(:models)

    average_prices = Model.group(:brand_id).average(:average_price)
  
    results = brands.map do |brand|
      {
        id: brand.id,
        nombre: brand.name,
        average_price: average_prices[brand.id]&.to_i || 0
      }
    end
  
    render json: results
  end

  def show
    render json: @brand
  end

  def models
    render json: @brand.models.select(:id, :name, :average_price)
  end

  def create
    brand = Brand.new(brand_params)
    if brand.save
      render json: brand, status: :created
    else
      render json: { error: brand.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def set_brand
    @brand = Brand.find_by(id: params[:brand_id])
    render json: { error: ['Marca no encontrada'] }, status: :not_found unless @brand
  end

  def brand_params
    params.require(:brand).permit(:name)
  end
end