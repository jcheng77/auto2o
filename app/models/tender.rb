class Tender < ActiveRecord::Base

  belongs_to :user

  # has_one :car
  has_many :bids
  has_one :bargain
  has_one :deal
  has_one :deposit

  state_machine :initial => :intention do

    before_transition :invite => any - :invite, :do => :check_deposit

    before_transition any => :bid_open, :do => :check_bid_time
    before_transition any => :final_bid_closed, :do => :check_final_bid_time

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
    tender_closed if Time.now > (self.created_at + 1.days)
  end

  def check_final_bid_time

  end

  def log_transaction
    Rails.logger.info("Start change state--------")
    yield
    Rails.logger.info("End change state----------")
  end

end
