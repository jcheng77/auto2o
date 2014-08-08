class CreateDeposits < ActiveRecord::Migration
  def change
    create_table :deposits do |t|
      t.integer :user_id
      t.integer :tender_id
      t.decimal :sum
      t.string :status

      t.timestamps
    end
  end
end
