class Deal < ActiveRecord::Base

  belongs_to :tender
  belongs_to :bid

end
