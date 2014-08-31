class Shop < ActiveRecord::Base

  has_many :dealers, inverse_of: :shop

end
