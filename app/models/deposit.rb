class Deposit < ActiveRecord::Base

  belongs_to :user
  belongs_to :tender

end
