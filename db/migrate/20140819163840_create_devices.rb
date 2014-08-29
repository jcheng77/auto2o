class CreateDevices < ActiveRecord::Migration
  def change
    create_table :devices do |t|
      t.integer :user_id
      t.integer :dealer_id
      t.integer :admin_user_id
      t.string :push_id
      t.string :type
      t.string :state

      t.timestamps
    end
  end
end
