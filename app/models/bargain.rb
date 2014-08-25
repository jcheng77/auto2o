class Bargain < ActiveRecord::Base


  belongs_to :user, inverse_of: :bargains
  belongs_to :tender, inverse_of: :bargain
  has_many :bids, inverse_of: :bargain


end
