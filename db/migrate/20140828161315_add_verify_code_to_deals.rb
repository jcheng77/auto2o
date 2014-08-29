class AddVerifyCodeToDeals < ActiveRecord::Migration
  def change
    add_column :deals, :verify_code, :string
    add_index(:deals, :verify_code, unique: true)
  end

end
