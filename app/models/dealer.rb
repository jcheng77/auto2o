class Dealer < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :registerable, #:sms_activable,
         :recoverable, :rememberable, :trackable, :validatable,
         :database_authenticatable, :authentication_keys => [:phone]

  has_many :devices, inverse_of: :dealer
  has_many :bids, inverse_of: :dealer
  has_many :deals, inverse_of: :dealer

  def email_required?
    false
  end

end
