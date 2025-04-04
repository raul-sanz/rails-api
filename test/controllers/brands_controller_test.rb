require "test_helper"

puts "================ INFORMACIÓN DE BASE DE DATOS ================"
puts "Adapter: #{ActiveRecord::Base.connection.adapter_name}"
puts "DB Name: #{ActiveRecord::Base.connection.current_database}"
puts "=============================================================="

class BrandsControllerTest < ActionDispatch::IntegrationTest


  setup do
    Brand.delete_all
    @brand = Brand.create!(name: "Toyota")
    @brand2 = Brand.create!(name: "Honda")
    @brand.models.create!(name: "Corolla", average_price: 300_000)
    @brand.models.create!(name: "Camry", average_price: 500_000)
  end

  test "should get index with average prices" do
    get brands_url
    assert_response :success

    body = JSON.parse(response.body)
    assert_equal 2, body.size

    toyota = body.find { |b| b["nombre"] == "Toyota" }
    assert_equal 400_000, toyota["average_price"]
  end

  test "should get models for brand" do
    get brand_models_url(@brand)
    assert_response :success

    body = JSON.parse(response.body)
    assert_equal 2, body.size
    assert_equal "Corolla", body[0]["name"]
  end

  test "should return 404 if brand not found in models" do
    get "/brands/999/models"
    assert_response :not_found

    body = JSON.parse(response.body)
    assert_equal "Marca no encontrada", body["error"].first
  end

  test "should create brand" do
    assert_difference("Brand.count") do
      post brands_url, params: { brand: { name: "Mazda" } }
    end
    assert_response :created

    body = JSON.parse(response.body)
    assert_equal "Mazda", body["name"]
  end

  test "should not create duplicate brand" do
    post brands_url, params: { brand: { name: "Toyota" } }
    assert_response :unprocessable_entity

    body = JSON.parse(response.body)
    assert_includes body["error"].first, "Name ya está registrado. Las marcas son únicas sin importar mayúsculas o minúsculas."
  end

  test "should not create case-insensitive duplicate brand" do
    post brands_url, params: { brand: { name: "toyota" } }
    assert_response :unprocessable_entity

    body = JSON.parse(response.body)
    assert_includes body["error"].first, "Name ya está registrado. Las marcas son únicas sin importar mayúsculas o minúsculas."
  end

  test "should return error if name is blank" do
    post brands_url, params: { brand: { name: "" } }
    assert_response :unprocessable_entity

    body = JSON.parse(response.body)
    assert_includes body["error"].first, "Name no puede estar vacío"
  end
end