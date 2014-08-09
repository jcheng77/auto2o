class CreateBids < ActiveRecord::Migration
  def change
    create_table :bids do |t|
      t.integer :tender_id
      t.integer :bargain_id
      t.integer :dealer_id
      t.decimal :price, precision: 12, scale: 2
      t.string :description
      t.string :state

      t.timestamps
    end
  end
end
