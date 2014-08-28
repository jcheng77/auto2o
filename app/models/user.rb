class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, #:sms_activable,
         :recoverable, :rememberable, :trackable, :validatable, :token_authenticatable, :omniauthable


  has_many :devices, inverse_of: :user
  has_many :tenders, inverse_of: :user

  has_many :deals, inverse_of: :user
  has_many :deposits, inverse_of: :user

  has_many :bargains

end
