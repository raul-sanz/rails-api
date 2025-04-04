class AddDefaultValueToAveragePriceInModels < ActiveRecord::Migration[8.0]
  def change
    change_column_default :models, :average_price, 0 
    change_column_null :models, :average_price, true
  end
end
