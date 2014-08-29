class CreateCarPics < ActiveRecord::Migration
  def change
    create_table :car_pics do |t|
    	t.string :pic_url
    	t.references :car_model
    	
      t.timestamps
    end
  end
end
