module Car
  class Color < ActiveRecord::Base

    self.table_name = 'car_colors'

    belongs_to :model


  end
end