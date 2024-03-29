class TendersController < InheritedResources::Base

  before_action :authenticate_user!, except: [:bid, :submit, :show_bargain, :dealer_index, :update_model, :new]
  before_action :authenticate_dealer!, only: [:dealer_index, :bid, :submit]

  before_action :set_tender, except: [:index, :dealer_index, :create, :new, :update_model, :update_trim]
                #, only: [:show, :edit, :update, :destroy, :bid, :bids_list, :final_bids, :submit, :bargain, :submit_bargain, :show_bargain]

  # GET /tenders
  # GET /tenders.json
  def index
    @tenders = current_user.tenders
                   .includes(:bargain, deal: [:dealer], car_trim: [model: [:pics]])
                   .order(id: :desc).page(params[:page]).per(10)

    respond_to do |format|
      format.html
      format.json
    end
  end

  def dealer_index
    @dealer = current_dealer
    if @dealer.shop.nil? && (@dealer.phone == '18601207073' || @dealer.phone == '18101880217')
    @tenders = Tender.where.not(state: %w(determined))
                      .includes(bargain: [bids:[:dealer]], deal: [dealer:[:shop]], car_trim: [model: [:pics]])
                      .order(id: :desc).page(params[:page]).per(10) 
    else
    @tenders = @dealer.shop.tenders.where.not(state: %w(determined))
                   .includes(bargain: [bids:[:dealer]], deal: [dealer:[:shop]], car_trim: [model: [:pics]])
                   .order(id: :desc).page(params[:page]).per(10)
    end

    respond_to do |format|
      format.html { render template: 'tenders/index' }
      format.json { render template: 'tenders/index' }
    end
  end

  # GET /tenders/1
  # GET /tenders/1.json
  # 用户支付完毕后，也重定向回来这里
  def show
    @deposit = @tender.deposit || @tender.build_deposit
    @shops = @tender.car_trim.brand.shops
    @selected_shops = @tender.shops
    @tender.state = 'qualified' if @tender.state == 'taken' # 暂态，不让终端用户知道
    @bid = @tender.bids.first if @tender.state == 'submitted' || @tender.state == 'deal_made'
    # 友好的提示当前订单的状态
    @deal ||= @tender.deal
    @dealer = @tender.deal.dealer if @deal
    if @dealer    
      @shop = @dealer.shop
      @dealer_comment = current_user.comments.build(dealer: @dealer, shop: @shop, deal: @deal)
      @shop_comment = current_user.comments.build(dealer: @dealer, shop: @shop, deal: @deal)
    end
    @colors = @tender.colors
    @trim = @tender.car_trim
    @brand = @trim.brand
    @maker = @trim.maker
    @model = @trim.model
    callback_params = params.except(*request.path_parameters.keys)
    if callback_params.any? && Alipay::Sign.verify?(callback_params)
      if @deposit.paid? || @deposit.completed?
        flash.now[:success] = I18n.t('deposit_paid_message')
      elsif @deposit.pending?
        flash.now[:info] = I18n.t('deposit_pendding_message')
      end
    end
  end

  # def finish_1st_round
  #   @tender.tender_closed!
  #   redirect_to tender_path(@tender)
  # end

  # def finish_2nd_round
  #   @tender.final_closed!
  #   redirect_to tender_path(@tender)
  # end
  # GET /tenders/new
  def new
    @tender = Tender.new
    if !params[:brand] && !params[:maker] && !params[:model] && !params[:trim]
      @brands = Car::Brand.all
      @models = Car::Model.all
    elsif params[:brand] && !params[:maker] && !params[:model] && !params[:trim]
      @makers = Car::Brand.find(params[:brand]).makers
    elsif params[:maker] && !params[:model] && !params[:trim]
      @maker = Car::Maker.find(params[:maker])
    elsif params[:model] 
      @model = Car::Model.find(params[:model])
      @trim = @model.trims.first
      @shops = ( @trim.brand.shops.size == 0 ? @model.shops : @trim.brand.shops )
      @colors = @trim.colors
      #@colors = Car::Color.find params[:color].keys
    end
  end

  def update_model
    @makers = Car::Brand.find(params[:brand_id]).makers
    @models = @makers.map {|m| m.models}
    @models.flatten!
    respond_to do |format| 
      format.js 
    end
  end


  def update_trim
    @trim = Car::Trim.find(params[:m_trim_id])
    respond_to do |format| 
      format.js 
    end
  end

  def update_shops

  end


  # GET /tenders/1/edit
  def edit
  end

  # POST /tenders
  # POST /tenders.json
  # Parameters: 
  # {
  #   "utf8"=>"✓", "authenticity_token"=>"+AHrewFQle1azO1bO9zCQFG2KtWzmUEJzRgUKkn2+YA=",
  #   "tender"=>{
  #     "model"=>"A3 Sportback 35TFSI 舒适型 冰川白, 阿玛菲白, 海南蓝, 白鲸棕",
  #     "trim_id"=>"1",
  #     "colors_ids"=>"1,6,9,11",
  #     "pickup_time"=>"尽快",
  #     "license_location"=>"上海",
  #     "got_licence"=>"0",
  #     "loan_option"=>"2",
  #     "price"=>"123",
  #     "shops"=>{"1"=>"1", "4"=>"1"}
  #   },
  #   "commit"=>"提交订单"
  # }

  def create
    @tender = Tender.new(new_tender_params)
    @trim = Car::Trim.find(params[:tender][:trim_id])
    @brand = @trim.brand
    @maker = @trim.maker
    @model = @trim.model
    @colors = Car::Color.find(params[:tender][:colors_ids].split(',').map(&:to_i))
    @tender.model = "#{@brand.name} : #{@maker.name} : #{@model.name} : #{@trim.name} : #{@colors.map(&:name).join(',')}"
    @tender.chose_subject!
    @tender.user = current_user

    # check daily tender count limit: total 4, per model 2
    now = Time.now
    unless current_user.is_test_user?
       daily_tenders = current_user.tenders.where(created_at: now.beginning_of_day..now.end_of_day)
       if daily_tenders.includes(car_trim:[:model]).select{ |t| t.car_trim.model == @model }.size >= 2
         reach_limit_count('同一车型每天最多下2单')
         return
       elsif daily_tenders.size >= 4
         reach_limit_count('每天最多下4单')
         return
       end
    end

    # mobile client submit fixed amount of deposit
    @deposit = current_user.deposits.new(tender: @tender, sum: (Deposit::AMOUNT - Deposit::DEFAULT_DISCOUNT))
    @deposit.save

    respond_to do |format|
      if @tender.save!
        if params[:shops]
	        @tender.shops << Shop.find(params[:shops].split(',').map(&:to_i))
        else
          @tender.shops << Shop.find(params[:tender][:shops].keys)
        end

        begin
          @bargain = @tender.build_bargain(price: params[:tender][:price])
          # @tender.submit_bargain!
          @bargain.save!
        rescue => e
          flash[:warning] = e.to_s
          Rails.logger.info(e)
          respond_to do |format|
            format.html { redirect_to(tenders_path) }
            format.json { render json: @tender.errors, status: :unprocessable_entity }
          end
          return
        end
	format.html { redirect_to @tender, notice: '拍立行君收到您的订单需求了，我们稍后联系您确认订单后，就会出发帮你砍价买车了.谢谢你选择我们做为你购车旅程的第一站. ' }
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
    if params[:shop].present?
      @tender.shops << Shop.find(params[:shop].keys)
    end
    respond_to do |format|
      if @tender.update(update_tender_params)
        format.html { redirect_to @tender, notice: 'User was successfully updated.' }
        format.json { render :show, status: :ok, location: @tender }
      else
        format.html { render :edit }
        format.json { render json: @tender.errors, status: :unprocessable_entity }
      end
    end
  end


  # PATCH/PUT /tenders/1
  # PATCH/PUT /tenders/1.json
  def confirm
    @tender.confirm_deal! 
    respond_to do |format|
      if @tender.save
        format.html { redirect_to @tender, notice: 'Tender is confirmed.' }
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

  # def invite
  #   @tender.invite_dealer
  #   # redirect_to @tender, notice: '竞标邀请已发出.'
  #   redirect_to bargain_tender_path(@tender)#, notice: '竞标邀请已发出.'
  # end

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

  # # POST /tender/1/submit
  # # POST /tender/1/submit.json
  # # submit first round bid
  # def submit
  #   @bid = Bid.new(bid_params)
  #   @bid.tender = @tender
  #   begin
  #     @tender.check_bid_time
  #     @tender.submit_tender!
  #     @bid.dealer = current_dealer
  #   rescue StateMachine::InvalidTransition => e
  #     flash[:warning] = e.to_s
  #     Rails.logger.info(e)
  #     redirect_to(tenders_path) and return
  #   end
  #   respond_to do |format|
  #     if @bid.save
  #       format.html { redirect_to @bid, notice: 'Tender was successfully created.' }
  #       format.json { render :show, status: :created, location: @bid }
  #     else
  #       format.html { render :new }
  #       format.json { render json: @bid.errors, status: :unprocessable_entity }
  #     end
  #   end
  # end


  # def cancel_1_round
  #   @tender.cancel_1_round!
  #   @reasons=[
  #     "reason1",
  #     "reason2",
  #     "reason3",
  #     "reason4"
  #   ]
  #   respond_to do |format|
  #     format.html { redirect_to @tender, notice: 'Tender was successfully canceled.' }
  #     format.json { render :cancel_1_round, status: :accepted, location: @tender }
  #   end
  # end

  # # GET /tender/1/bargain
  # # GET /tender/1/bargain.json
  # def bargain
  #   @bargain = @tender.build_bargain
  #   @terms = [
  #     "取消还价保证金不能全额退回",
  #     "成交后超期不去现场交易保证金不能全额退回"
  #   ]
  # end

  # GET /tender/1/show_bargain
  # GET /tender/1/show_bargain.json
  def show_bargain
    @bargain = @tender.bargain
    @trim    = @tender.car_trim
    @colors  = @tender.colors
    @bid     = @bargain.bids.new if @bargain
  end

  # # POST /tender/1/submit_bargain
  # # POST /tender/1/submit_bargain.json
  # def submit_bargain
  #   begin
  #     @bargain = @tender.build_bargain(bargain_params)
  #     @tender.submit_bargain!
  #   rescue StateMachine::InvalidTransition => e
  #     flash[:warning] = e.to_s
  #     Rails.logger.info(e)
  #     respond_to do |format|
  #       format.html { redirect_to(tenders_path) }
  #       format.json { render json: @tender.errors, status: :unprocessable_entity }
  #     end
  #     return
  #   end
  #   respond_to do |format|
  #     if @bargain.save
  #       format.html { redirect_to @tender, notice: 'Tender was successfully created.' }
  #       format.json { render :show, status: :created, location: @bargain }
  #     else
  #       format.html { render :new }
  #       format.json { render json: @bargain.errors, status: :unprocessable_entity }
  #     end
  #   end
  # end

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


  # def cancel_2_round
  #   @tender.cancel_2_round!
  #   @reasons=[
  #     "reason1",
  #     "reason2",
  #     "reason3",
  #     "reason4"
  #   ]
  #   respond_to do |format|
  #     format.html { redirect_to @tender, notice: 'Tender was successfully canceled.' }
  #     format.json { render :cancel_1_round, status: :accepted, location: @tender }
  #   end
  # end

  # def cancel_2_round
  #   @tender.cancel_2_round!
  #   @reasons=[
  #     "4s店优惠不给力",
  #     "4s店距离太远了",
  #     "信息提交错误",
  #     "选择其他车型了",
  #     "推迟购买计划了"
  #   ]
  #   respond_to do |format|
  #     format.html { redirect_to @tender, notice: 'Tender was successfully canceled.' }
  #     format.json { render :cancel_1_round, status: :accepted, location: @tender }
  #   end
  # end

  def cancel
    @tender.cancel_deal!
    @tender.cancel_reason = cancel_tender_params[:cancel_reason]
    respond_to do |format|
      if @tender.save
        format.html { redirect_to @tender, notice: 'Tender was successfully canceled.' }
        format.json { render json: { status: :ok } }
      else
        format.html { render :new }
        format.json { render json: @tender.errors, status: :unprocessable_entity }
      end
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_tender
    @tender = Tender.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def new_tender_params
    params.require(:tender)
    params[:tender].require(:price)
    # params[:tender].require(:description)
    params[:tender].require(:trim_id)
    unless params[:tender][:shops]
      params.require(:shops)
    end
    unless params[:shops]
      params[:tender].require(:shops)
    end

    params[:tender].require(:pickup_time)
    params[:tender].require(:license_location)
    params[:tender].require(:colors_ids)
    params[:tender].require(:user_name)
    params.require(:tender).permit(:model, :price, :description, :trim_id, :pickup_time, :license_location, :got_licence, :loan_option, :colors_ids, :shops,
                                   :user_name)
  end

  def update_tender_params
    params.require(:tender).permit(:price, :description, :shop)
  end

  def bid_params
    params.require(:bid).permit(:price, :description)
  end
  
  def cancel_tender_params
    params.require(:tender)
    params[:tender].require(:cancel_reason)
    params.require(:tender).permit(:cancel_reason) 
  end

  # def bargain_params
  #   params.require(:bargain).permit(:price, :postscript)
  # end

  def reach_limit_count(error)
    flash[:warning] = error
    respond_to do |format|
      format.html { redirect_to(tenders_path) }
      format.json { render json: {error: error}, status: :unprocessable_entity }
    end
  end

end
