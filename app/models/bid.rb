class Bid < ActiveRecord::Base

  belongs_to :dealer, inverse_of: :bids

  belongs_to :tender, inverse_of: :bids, counter_cache: true
  belongs_to :bargain, inverse_of: :bids, counter_cache: true

  has_one :deal, inverse_of: :bid


  state_machine :initial => :intention do
    after_transition any => :submitted do |bid, transition|
      bid.noty_user_deal_made
    end

    event :make_final do
      transition :intention => :submitted
    end
  end

  def noty_user_deal_made
    Push.baidu_push(self.deal.user, "您的订单已成交")
  end

end
