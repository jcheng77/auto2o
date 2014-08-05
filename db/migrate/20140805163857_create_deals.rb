class CreateDeals < ActiveRecord::Migration
  def change
    create_table :deals do |t|
      t.integer :user_id
      t.integer :tender_id
      t.integer :bid_id
      t.integer :bargain_id
      t.integer :dealer_id
      t.decimal :final_price
      t.string :postscript

      t.timestamps
    end
  end
end
