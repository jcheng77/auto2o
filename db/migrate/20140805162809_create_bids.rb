class CreateBids < ActiveRecord::Migration
  def change
    create_table :bids do |t|
      t.integer :tender_id
      t.integer :dealer_id
      t.decimal :price, precision: 12, scale: 2
      t.string :description

      t.timestamps
    end
  end
end
