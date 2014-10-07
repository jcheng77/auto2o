class AlterTenderColorId < ActiveRecord::Migration
  def change
    remove_column :tenders, :color_id
    add_column :tenders, :colors_ids, :string
  end
end
