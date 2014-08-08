class Tender < ActiveRecord::Base

  belongs_to :user

  # has_one :car
  has_many :bids
  has_one :bargain
  has_one :deal

end
