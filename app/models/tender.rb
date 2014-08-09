class Tender < ActiveRecord::Base

  belongs_to :user

  # has_one :car
  has_many :bids
  has_one :bargain
  has_one :deal

  state_machine :initial => :intention do
    before_transition :invite => any - :invite, :do => :check_user
    after_transition any => :closed do |tender, transition|
      # tender.noty_all
    end
    around_transition :log_transaction

    event :initiate do
      transition :intention => :invite
    end

    state :invite, :bargaining do
      validates_presence_of :model
      validates_presence_of :price
    end
  end

  # before start tender valid user
  def check_user

  end

  # before start check the deposit
  def check_deposit

  end

  def log_transaction
    Rails.logger.info("start ")
    yield
    Rails.logger.info("End ")
  end

end
