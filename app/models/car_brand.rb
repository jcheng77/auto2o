class CarBrand < ActiveRecord::Base
	has_many :car_makers
end
