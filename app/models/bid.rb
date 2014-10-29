class Bid < ActiveRecord::Base

  belongs_to :dealer, inverse_of: :bids

  belongs_to :tender, inverse_of: :bids, counter_cache: true
  belongs_to :bargain, inverse_of: :bids, counter_cache: true

  has_one :deal, inverse_of: :bid


  state_machine :initial => :intention do

    event :make_final do
      transition :intention => :submitted
    end

  end

end
