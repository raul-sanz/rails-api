require "test_helper"

class ModelsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @brand = Brand.create!(name: "Nissan")
    @model = @brand.models.create!(name: "Versa", average_price: 250_000)
  end

  test "should get index" do
    get models_url
    assert_response :success

    body = JSON.parse(response.body)
    assert body.any?
    assert_equal @model.id, body.first["id"]
  end

  test "should filter models by greater param" do
    get models_url, params: { greater: 200_000 }
    assert_response :success

    body = JSON.parse(response.body)
    assert body.any?
    assert_operator body.first["average_price"], :>, 200_000
  end

  test "should filter models by lower param" do
    get models_url, params: { lower: 300_000 }
    assert_response :success

    body = JSON.parse(response.body)
    assert body.any?
    assert_operator body.first["average_price"], :<, 300_000
  end

  test "should update model average_price" do
    put model_url(@model), params: { model: { average_price: 400_000 } }
    assert_response :success

    @model.reload
    assert_equal 400_000, @model.average_price
  end

  test "should not update model with invalid average_price" do
    put model_url(@model), params: { model: { average_price: 99_999 } }
    assert_response :unprocessable_entity

    body = JSON.parse(response.body)
    assert_includes body["error"].first, "Debe ser mayor a 100,000"
  end
end
