class AddCancelReasonToTenders < ActiveRecord::Migration
  def change
    add_column :tenders, :cancel_reason, :string
  end
end
