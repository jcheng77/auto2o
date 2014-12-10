class AddViewCountToCarTrims < ActiveRecord::Migration
  def change
    add_column :car_trims, :view_count, :integer
  end
end
