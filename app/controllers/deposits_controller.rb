class DepositsController < InheritedResources::Base

  skip_before_filter :verify_authenticity_token, :only => [:alipay_app_notify]

  before_action :authenticate_user!, :except => [:alipay_app_notify]
  before_action :set_deposit, only: [:edit, :update, :destroy]

  # 创建订单
  def create
    @deposit = current_user.deposits.new(deposit_params)

    @tender = Tender.find(deposit_params[:tender_id])
    @deposit.tender = @tender
    
    @tender.invite_dealer # TODO notify dealers
    @tender.submit_margin # TODO remove

    respond_to do |format|
      if @deposit.save
        format.html { redirect_to @deposit.pay_url }
        # format.html { redirect_to @deposit.tender, notice: 'Tender was successfully created.' }
        format.json { render :show, status: :created, location: @deposit }
      else
        format.html { redirect_to tender_path(@tender), notice: '订金订单创建失败，请重试.' }
        format.json { render json: @deposit.errors, status: :unprocessable_entity }
      end
    end
  end

  def alipay_app_notify
    notify_params = params.except(*request.path_parameters.keys, :deposit)
    if Alipay::Notify::App.verify?(notify_params)
      # 获取交易关联的订单
      @deposit = Tender.find(params[:out_trade_no].split(":").last).deposit

      case params[:trade_status]
      # 交易状态TRADE_SUCCESS的通知触发条件是商户签约的产品支持退款功能 的前提下,买家付款成功
      when 'TRADE_SUCCESS'
        @deposit.pay
        @deposit.complete
      # 交易开启
      when 'WAIT_BUYER_PAY'
        @deposit.update_attribute :trade_no, params[:trade_no]
        @deposit.confirm_term
      when 'WAIT_SELLER_SEND_GOODS'
        # 买家完成支付
        @deposit.pay
        # 虚拟物品无需发货，所以立即调用发货接口
        @deposit.send_good
      # 交易状态TRADE_FINISHED的通知触发条件是商户签约的产品不支持退款功 能的前提下,买家付款成功;或者,商户签约的产品支持退款功能的前提下, 交易已经成功并且已经超过可退款期限  
      # 交易完成
      when 'TRADE_FINISHED'
        @deposit.pay
        @deposit.complete
      when 'TRADE_CLOSED'
        # 交易被关闭
        @deposit.cancel
      end
      render :text => 'success'
    else
      render :text => 'error'
    end
  end

  # 支付宝异步消息接口
  def alipay_web_notify
    notify_params = params.except(*request.path_parameters.keys)
    # 先校验消息的真实性
    if Alipay::Sign.verify?(notify_params) && Alipay::Notify.verify?(notify_params)
      # 获取交易关联的订单
      @deposit = self.class.find params[:out_trade_no]

      case params[:trade_status]
      when 'WAIT_BUYER_PAY'
        # 交易开启
        @deposit.update_attribute :trade_no, params[:trade_no]
        @deposit.pend
      when 'WAIT_SELLER_SEND_GOODS'
        # 买家完成支付
        @deposit.pay
        # 虚拟物品无需发货，所以立即调用发货接口
        @deposit.send_good
      when 'TRADE_FINISHED'
        # 交易完成
        @deposit.complete
      when 'TRADE_CLOSED'
        # 交易被关闭
        @deposit.cancel
      end

      render :text => 'success' # 成功接收消息后，需要返回纯文本的 ‘success’，否则支付宝会定时重发消息，最多重试7次。
    else
      render :text => 'error'
    end
  end

private

  # Use callbacks to share common setup or constraints between actions.
  def set_deposit
    @deposit = Deposit.find(params[:id])
  end

  def deposit_params
    params.require(:deposit).permit(:sum, :tender_id, :quantity)
  end

end
