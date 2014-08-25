class Bid < ActiveRecord::Base

  belongs_to :dealer, inverse_of: :bids

  belongs_to :tender, inverse_of: :bids
  belongs_to :bargain, inverse_of: :bids

  has_one :deal, inverse_of: :bid

end
