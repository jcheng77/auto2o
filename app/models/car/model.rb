module Car
  class Model < ActiveRecord::Base

    self.table_name = 'car_models'

    belongs_to :maker
    has_many :pics
    has_many :trims
    has_many :colors

  end
end