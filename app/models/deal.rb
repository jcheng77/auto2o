class Deal < ActiveRecord::Base

  belongs_to :user, inverse_of: :deals
  belongs_to :dealer, inverse_of: :deals
  belongs_to :tender, inverse_of: :deal
  belongs_to :bid, inverse_of: :deal

end
