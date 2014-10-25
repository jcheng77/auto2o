class Deal < ActiveRecord::Base

  belongs_to :user, inverse_of: :deals
  belongs_to :dealer, inverse_of: :deals
  belongs_to :tender, inverse_of: :deal
  belongs_to :bid, inverse_of: :deal

  state_machine :initial => :new do

    event :do_verify do
      transition :new => :verified
    end

  end

  def self.gen_verify_code
    SecureRandom.urlsafe_base64(40)
  end

end
