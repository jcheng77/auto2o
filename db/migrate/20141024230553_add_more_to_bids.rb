class AddMoreToBids < ActiveRecord::Migration
  def change
    add_column :bids, :insurance, :decimal, precision: 12, scale: 2
    add_column :bids, :vehicle_tax, :decimal, precision: 12, scale: 2
    add_column :bids, :purchase_tax, :decimal, precision: 12, scale: 2
    add_column :bids, :license_fee, :decimal, precision: 12, scale: 2
    add_column :bids, :misc_fee, :decimal, precision: 12, scale: 2
  end
end
