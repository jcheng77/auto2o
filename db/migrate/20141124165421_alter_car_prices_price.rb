class AlterCarPricesPrice < ActiveRecord::Migration
  def change
  	change_column :car_prices, :price, :decimal, precision: 12, scale: 2
  end
end
