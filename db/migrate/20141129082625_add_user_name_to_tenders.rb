class AddUserNameToTenders < ActiveRecord::Migration
  def change
    add_column :tenders, :user_name, :string
  end
end
