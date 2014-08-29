class CarTrim < ActiveRecord::Base
	belongs_to :car_model
	has_many :car_colors, through: :car_model
end
