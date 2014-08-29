class CarMaker < ActiveRecord::Base
	belongs_to :car_brand
	has_many :car_models
end
