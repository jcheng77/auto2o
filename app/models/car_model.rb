class CarModel < ActiveRecord::Base
	belongs_to :car_maker
	has_many :car_pics
	has_many :car_trims
	has_many :car_colors
end
