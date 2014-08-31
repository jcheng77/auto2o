class AddBidsCountToTender < ActiveRecord::Migration
  def change
    add_column :tenders, :bids_count, :integer
  end
end
