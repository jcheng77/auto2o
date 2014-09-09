module Car
  class Trim < ActiveRecord::Base

    self.table_name = 'car_trims'

    belongs_to :model
    has_many :colors, through: :model

    has_many :tenders, inverse_of: :car_trim
  end
end