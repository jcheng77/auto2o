class CreateTenders < ActiveRecord::Migration
  def change
    create_table :tenders do |t|
      t.string :model
      t.decimal :price, precision: 12, scale: 2
      t.string :description

      t.timestamps
    end
  end
end
