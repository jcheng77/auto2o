class CreateTenders < ActiveRecord::Migration
  def change
    create_table :tenders do |t|
      t.integer :user_id
      t.integer :trim_id
      t.integer :color_id
      t.string :model
      t.decimal :price, precision: 12, scale: 2
      t.string :description
      t.string :state

      t.timestamps
    end
  end
end
