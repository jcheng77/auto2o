class AddLastResetAtToDealers < ActiveRecord::Migration
  def change
    add_column :dealers, :last_reset_at, :datetime
  end
end
