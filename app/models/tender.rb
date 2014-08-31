class Tender < ActiveRecord::Base

  belongs_to :user, inverse_of: :tenders

  has_many :bids, inverse_of: :tender
  has_one :bargain, inverse_of: :tender
  has_one :deal, inverse_of: :tender
  has_one :deposit, inverse_of: :tender
  belongs_to :car, inverse_of: :tenders

  state_machine :initial => :intention do

    before_transition :invite => any - :invite, :do => :check_deposit

    before_transition any - :bid_closed => :bid_open, :do => :check_bid_time
    before_transition any => :final_bid_closed, :do => :check_final_bid_time
    before_transition any => :round_2_canceled, :do => :deal_with_deposit

    after_transition any => :closed do |tender, transition|
      # tender.noty_all
    end

    around_transition :log_transaction

    event :chose_subject do
      transition :intention => :determined
    end

    event :submit_margin do
      transition :determined => :qualified
    end

    event :invite_dealer do
      transition :qualified => :invite
    end

    event :submit_tender do
      transition [:invite, :bid_open] => :bid_open
    end

    event :tender_closed do
      transition :bid_open => :bid_closed
    end

    # user can make deal in the middle or end of the first round of bid
    event :make_deal do
      transition [:bid_open, :bid_closed] => :deal_closed
    end

    event :cancel_1_round do
      transition [:intention, :determined, :bid_closed, :qualified, :invite, :bid_open, :bid_closed, :deal_closed] => :round_1_canceled
    end

    # if user not satisfied with result of first round, bargain
    event :submit_bargain do
      transition :bid_closed => :bargain_started
    end

    event :submit_final do
      transition [:bargain_started, :final_bid_open] => :final_bid_open
    end

    event :final_closed do
      transition :final_bid_open => :final_bid_closed
    end

    event :make_final_deal do
      transition [:final_bid_open, :final_bid_closed] => :final_deal_closed
    end

    event :cancel_2_round do
      transition [:bargain_started, :final_bid_open, :final_bid_closed, :final_deal_closed] => :round_2_canceled
    end

    state :determined do
      validates_presence_of :model
      # validates_presence_of :price
    end

  end

  # before start tender valid user
  def check_user

  end

  # before start check the deposit
  def check_deposit
    self.deposit.present?
  end

  def check_bid_time
    # tender_closed if Time.now > (self.created_at + 1.days)
  end

  def check_final_bid_time
    final_closed if Time.now > (self.created_at + 1.days)
  end

  def deal_with_deposit
    if self.deal.present?
      # refund to dealer, user, forfeiture of deposit
    else
      # refund to user, forfeiture of deposit
    end
    Rails.logger.info("deal_with_deposit --------")
  end

  def log_transaction
    Rails.logger.info("Start change state--------")
    yield
    Rails.logger.info("End change state----------")
  end

  def self.close
    self.where(state: 'bid_open').where("NOW() > DATE_ADD(created_at, INTERVAL 1 DAY)").update_all(state: 'bid_closed')
  end

end
