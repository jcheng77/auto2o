class Dealer < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :registerable, #:sms_activable,
         :recoverable, :rememberable, :trackable, :validatable,
         :database_authenticatable, :authentication_keys => [:phone]

  has_many :devices, inverse_of: :dealer
  has_many :baidu_devices, inverse_of: :dealer, class_name: '::BaiduDevice'
  has_many :bids, inverse_of: :dealer
  has_many :deals, inverse_of: :dealer
  has_many :comments, inverse_of: :dealer

  belongs_to :shop, inverse_of: :dealers

  IPHONE_REDEEM_POINTS = 6000

  def email_required?
    false
  end

  def points_up(num)
    self.points += num
  end

  def checkin_today?
    self.last_checkin_at == Time.now.to_date
  end

  def checkin
    unless checkin_today?
      self.last_checkin_at = Time.now.to_date
      self.points_up(1)
    end
  end

end
