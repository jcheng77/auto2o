class CreateDeposits < ActiveRecord::Migration
  def change
    create_table :deposits do |t|
      t.integer :user_id
      t.integer :tender_id
      t.decimal :sum
      t.string :state
      t.string :trade_no
      t.string :broker_type

      t.timestamps
    end
  end
end
