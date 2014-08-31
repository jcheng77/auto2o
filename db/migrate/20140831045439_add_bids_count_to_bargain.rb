class AddBidsCountToBargain < ActiveRecord::Migration
  def change
    add_column :bargains, :bids_count, :integer
  end
end
