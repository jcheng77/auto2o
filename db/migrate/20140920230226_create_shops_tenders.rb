class CreateShopsTenders < ActiveRecord::Migration
  def change
    create_table :shops_tenders do |t|
      t.integer :shop_id
      t.integer :tender_id
    end
  end
end
