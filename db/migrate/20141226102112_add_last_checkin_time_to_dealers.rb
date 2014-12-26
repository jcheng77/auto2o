class AddLastCheckinTimeToDealers < ActiveRecord::Migration
  def change
    add_column :dealers, :last_checkin_at, :date
  end
end
