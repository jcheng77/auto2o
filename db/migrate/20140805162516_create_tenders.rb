class CreateTenders < ActiveRecord::Migration
  def change
    create_table :tenders do |t|
      t.string :model
      t.decimal :price
      t.string :description

      t.timestamps
    end
  end
end
