class Comment < ActiveRecord::Base

  belongs_to :shop, inverse_of: :comments
  belongs_to :dealer, inverse_of: :comments
  belongs_to :deal, inverse_of: :comment  
  
end
