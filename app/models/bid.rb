class Bid < ActiveRecord::Base

  belongs_to :dealer

  belongs_to :tender
  belongs_to :bargain

  has_one :deal

end
