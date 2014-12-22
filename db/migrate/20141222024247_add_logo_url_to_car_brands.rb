class AddLogoUrlToCarBrands < ActiveRecord::Migration
  def change
  	add_column :car_brands, :logo_url, :string
  end
end
