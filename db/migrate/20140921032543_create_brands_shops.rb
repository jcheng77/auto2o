class CreateBrandsShops < ActiveRecord::Migration
  def change
    create_table :brands_shops do |t|
      t.integer :brand_id
      t.integer :shop_id
    end
  end
end
