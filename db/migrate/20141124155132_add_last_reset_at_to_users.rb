class AddLastResetAtToUsers < ActiveRecord::Migration
  def change
    add_column :users, :last_reset_at, :datetime
  end
end
