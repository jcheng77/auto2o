class CreatePosts < ActiveRecord::Migration
  def change
    create_table :posts do |t|
      t.string :title
      t.string :description
      t.string :url
      t.string :pic_url

      t.timestamps
    end
  end
end
