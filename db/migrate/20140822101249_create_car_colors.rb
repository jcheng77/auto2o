class CreateCarColors < ActiveRecord::Migration
  def change
    create_table :car_colors do |t|
    	t.string :name
    	t.string :code
    	t.references :car_model

      t.timestamps
    end
  end
end
