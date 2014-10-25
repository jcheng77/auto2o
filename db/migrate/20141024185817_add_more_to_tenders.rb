class AddMoreToTenders < ActiveRecord::Migration
  def change
    add_column :tenders, :pickup_time, :string
    add_column :tenders, :license_location, :string
    add_column :tenders, :got_licence, :integer, limit: 1
    add_column :tenders, :loan_option, :integer
  end
end
