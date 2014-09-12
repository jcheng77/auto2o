class TendersController < InheritedResources::Base

  before_action :authenticate_user!, except: [:index, :bid, :submit]
  before_action :authenticate_dealer!, only: [:bid, :submit]

  before_action :set_tender, except: [:index, :create, :new]
                #, only: [:show, :edit, :update, :destroy, :bid, :bids_list, :final_bids, :submit, :bargain, :submit_bargain, :show_bargain]

  # GET /tenders
  # GET /tenders.json
  def index
    @tenders = Tender.includes(:bargain).all

    respond_to do |format|
      format.html
      format.json
    end
  end

  # GET /tenders/1
  # GET /tenders/1.json
  # 用户支付完毕后，也重定向回来这里
  def show
    @deposit = @tender.deposit || @tender.build_deposit

    # 友好的提示当前订单的状态
    callback_params = params.except(*request.path_parameters.keys)
    if callback_params.any? && Alipay::Sign.verify?(callback_params)
      if @deposit.paid? || @deposit.completed?
        flash.now[:success] = I18n.t('deposit_paid_message')
      elsif @deposit.pending?
        flash.now[:info] = I18n.t('deposit_pendding_message')
      end
    end
  end

  def finish_1st_round
    @tender.tender_closed!
    redirect_to tender_path(@tender)
  end

  def finish_2nd_round
    @tender.final_closed!
    redirect_to tender_path(@tender)
  end

  # GET /tenders/new
  def new
    @tender = Tender.new
  end

  # GET /tenders/1/edit
  def edit
  end

  # POST /tenders
  # POST /tenders.json
  def create
    @tender = Tender.new(tender_params)
    @tender.chose_subject if @tender.model.present?
    # @tender.car = Car.find_by_model(params[:model])
    @tender.user = current_user
    respond_to do |format|
      if @tender.save
        format.html { redirect_to @tender, notice: 'Tender was successfully created.' }
        format.json { render :show, status: :created, location: @tender }
      else
        format.html { render :new }
        format.json { render json: @tender.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /tenders/1
  # PATCH/PUT /tenders/1.json
  def update
    respond_to do |format|
      if @tender.update(tender_params)
        format.html { redirect_to @tender, notice: 'User was successfully updated.' }
        format.json { render :show, status: :ok, location: @tender }
      else
        format.html { render :edit }
        format.json { render json: @tender.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /tenders/1
  # DELETE /tenders/1.json
  def destroy
    @tender.destroy
    respond_to do |format|
      format.html { redirect_to tenders_url, notice: 'User was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def invite
    @tender.invite_dealer
    redirect_to @tender, notice: '竞标邀请已发出.'
  end

  # GET /tender/1/bid
  # GET /tender/1/bid.json
  def bid
    @bid = @tender.bids.new
  end

  # GET /tender/1/bid_list
  # GET /tender/1/bid_list.json
  def bids_list
    @bids = @tender.bids
  end

  def final_bids
    @bids = @tender.bargain.bids if @tender.bargain
  end

  # POST /tender/1/submit
  # POST /tender/1/submit.json
  # submit first round bid
  def submit
    @bid = Bid.new(bid_params)
    @bid.tender = @tender
    begin
      @tender.check_bid_time
      @tender.submit_tender!
      @bid.dealer = current_dealer
    rescue StateMachine::InvalidTransition => e
      flash[:warning] = e.to_s
      Rails.logger.info(e)
      redirect_to(tenders_path) and return
    end
    respond_to do |format|
      if @bid.save
        format.html { redirect_to @bid, notice: 'Tender was successfully created.' }
        format.json { render :show, status: :created, location: @bid }
      else
        format.html { render :new }
        format.json { render json: @bid.errors, status: :unprocessable_entity }
      end
    end
  end


  def cancel_1_round
    @tender.cancel_1_round!
    @reasons=[
      "reason1",
      "reason2",
      "reason3",
      "reason4"
    ]
    respond_to do |format|
      format.html { redirect_to @tender, notice: 'Tender was successfully canceled.' }
      format.json { render :cancel_1_round, status: :accepted, location: @tender }
    end
  end

  # GET /tender/1/bargain
  # GET /tender/1/bargain.json
  def bargain
    @bargain = @tender.build_bargain
    @terms = [
      "取消还价保证金不能全额退回",
      "成交后超期不去现场交易保证金不能全额退回"
    ]
  end

  # GET /tender/1/show_bargain
  # GET /tender/1/show_bargain.json
  def show_bargain
    @bargain = @tender.bargain
    @bid = @bargain.bids.new if @bargain
  end

  # POST /tender/1/submit_bargain
  # POST /tender/1/submit_bargain.json
  def submit_bargain
    begin
      @bargain = @tender.build_bargain(bargain_params)
      @tender.submit_bargain!
    rescue StateMachine::InvalidTransition => e
      flash[:warning] = e.to_s
      Rails.logger.info(e)
      respond_to do |format|
        format.html { redirect_to(tenders_path) }
        format.json { render json: @tender.errors, status: :unprocessable_entity }
      end
      return
    end
    respond_to do |format|
      if @bargain.save
        format.html { redirect_to @bargain, notice: 'Tender was successfully created.' }
        format.json { render :show, status: :created, location: @bargain }
      else
        format.html { render :new }
        format.json { render json: @bargain.errors, status: :unprocessable_entity }
      end
    end
  end

  def bid_final
    @bid = @tender.bids.new
  end

  def submit_2_round
    @bid = Bid.new(bid_params)
    @bid.tender = @tender
    @bid.bargain = @tender.bargain
    begin
      @tender.check_final_bid_time
      @tender.submit_final!
      @bid.dealer = current_dealer
    rescue StateMachine::InvalidTransition => e
      flash[:warning] = e.to_s
      Rails.logger.info(e)
      redirect_to(tenders_path) and return
    end
    respond_to do |format|
      if @bid.save
        format.html { redirect_to @bid, notice: 'Tender was successfully created.' }
        format.json { render :show, status: :created, location: @bid }
      else
        format.html { render :new }
        format.json { render json: @bid.errors, status: :unprocessable_entity }
      end
    end
  end


  def cancel_2_round
    @tender.cancel_2_round!
    @reasons=[
      "reason1",
      "reason2",
      "reason3",
      "reason4"
    ]
    respond_to do |format|
      format.html { redirect_to @tender, notice: 'Tender was successfully canceled.' }
      format.json { render :cancel_1_round, status: :accepted, location: @tender }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_tender
    @tender = Tender.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def tender_params
    params.require(:tender).permit(:model, :price, :description)
  end

  def bid_params
    params.require(:bid).permit(:price, :description)
  end

  def bargain_params
    params.require(:bargain).permit(:price, :postscript)
  end

end
