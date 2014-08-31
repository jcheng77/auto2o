class AddRoleAndShopIdToDealer < ActiveRecord::Migration
  def change
    add_column :dealers, :role, :string
    add_column :dealers, :shop_id, :integer
  end
end
