class CreateBargains < ActiveRecord::Migration
  def change
    create_table :bargains do |t|
      t.integer :user_id
      t.integer :tender_id
      t.integer :bid_id
      t.integer :dealer_id
      t.decimal :price
      t.string :postscript

      t.timestamps
    end
  end
end
