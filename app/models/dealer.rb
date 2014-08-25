class Dealer < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :devices, inverse_of: :dealer
  has_many :bids, inverse_of: :dealer
  has_many :deals, inverse_of: :dealer

end
