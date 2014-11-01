#encoding: utf-8

class Deposit < ActiveRecord::Base

  belongs_to :user, inverse_of: :deposits
  belongs_to :tender, inverse_of: :deposit


  state_machine :initial => :pending do

    before_transition :invite => any - :submitted, :do => :check_sum

    after_transition any => :completed do |deposit, transition|
      # tender.noty_all
      deposit.tender.submit_margin!
    end

    around_transition :log_transaction

    event :confirm_term do
      transition :pending => :opening
    end

    event :pay do
      transition :opening => :submitted
    end

    event :complete do
      transition :submitted => :completed
    end

    event :cancel do
      transition [:pending, :opening] => :canceled
    end

  end

  def pay_url
    Alipay::Service.create_partner_trade_by_buyer_url(
      :out_trade_no      => id.to_s,
      :price             => calculate_sum,
      :quantity          => 1,
      :discount          => discount,
      :subject           => "JustBitIt #{self.tender.model} 订金 x #{calculate_sum}",
      :logistics_type    => 'DIRECT',
      :logistics_fee     => '0',
      :logistics_payment => 'SELLER_PAY',
      :return_url        => Rails.application.routes.url_helpers.tender_url(self.tender, :host => 'localhost:3001'),
      :notify_url        => Rails.application.routes.url_helpers.alipay_notify_deposits_url(:host => 'localhost:3001'),
      :receive_name      => 'none', # 这里填写了收货信息，用户就不必填写
      :receive_address   => 'none',
      :receive_zip       => '100000',
      :receive_mobile    => '100000000000'
    )
  end


  def send_good
    Alipay::Service.send_goods_confirm_by_platform(
      :trade_no => trade_no,
      :logistics_name => 'JustBitIT',
      :transport_type => 'DIRECT' # 无需物流
    )
    self.tender.shops.first.dealers.each do |dealer|
      Sms.noty_new_tender(dealer.phone, self.tender)
    end
  end

  def log_transaction
    Rails.logger.info("Start change state--------")
    yield
    Rails.logger.info("End change state----------")
  end

  # base on price of car
  def calculate_sum
    1000000000000
  end

  def check_sum

  end

  def discount

  end

end
