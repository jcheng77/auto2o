class AddPointsToDealers < ActiveRecord::Migration
  def change
    add_column :dealers, :points , :integer, :default => 0
  end
end
