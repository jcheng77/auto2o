class AddAlipayAccountToDeposit < ActiveRecord::Migration
  def change
    add_column :deposits, :aplipay_account, :string
  end
end
