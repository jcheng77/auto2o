class Bargain < ActiveRecord::Base


  belongs_to :user
  belongs_to :tender
  has_many :bids
  
  
end
