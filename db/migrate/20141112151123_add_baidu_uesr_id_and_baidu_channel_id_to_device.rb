class AddBaiduUesrIdAndBaiduChannelIdToDevice < ActiveRecord::Migration
  def change
    add_column :devices, :baidu_user_id, :string
    add_column :devices, :baidu_channel_id, :string
  end
end
