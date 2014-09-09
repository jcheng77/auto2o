module Car
  class Brand < ActiveRecord::Base

    self.table_name = 'car_brands'

    has_many :makers

  end
end