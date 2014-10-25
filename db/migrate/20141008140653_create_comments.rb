class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.integer :shop_id
      t.integer :dealer_id
      t.text :content
      t.integer :rate

      t.timestamps
    end
  end
end
