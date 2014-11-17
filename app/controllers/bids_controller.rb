class BidsController < InheritedResources::Base

  before_action :authenticate_dealer! #, except: [:accept_final]
  # before_action :authenticate_user!, only: [:accept_final]

  before_action :set_bid, except: [:index, :create, :new]

  def index
    @bids = current_dealer.bids.all
  end

  def show
    @tender = @bid.tender
  end

  def update
    respond_to do |format|
      if @bid.update(update_params)
        @bid.price = @bid.tender.price +
                     @bid.insurance +
                     # @bid.vehicle_tax +
                     @bid.purchase_tax +
                     @bid.license_fee +
                     @bid.misc_fee

        @deal = @bid.build_deal(final_price: @bid.price, postscript: @bid.description, verify_code: Deal.gen_verify_code)
        @deal.tender = @bid.tender
        @deal.dealer = @bid.dealer
        @deal.user   = current_user

        @bid.tender.submit_total_price!
        @bid.tender.accept_price!
        @bid.make_final!
        @bid.save

        if @deal.save!
          format.html { redirect_to @bid, notice: '已给客户报价' }
          format.json { render :show, status: :ok, location: @bid }
        else
          format.html { render :edit }
          format.json { render json: @deal.errors, status: :unprocessable_entity }
        end
      else
        format.html { render :edit }
        format.json { render json: @bid.errors, status: :unprocessable_entity }
      end
    end
  end

  def create
    @bargain = Bargain.find(params[:bid][:bargain_id])
    # @bid = Bid.new(bid_params)
    @bid = Bid.new(price: @bargain.tender.price)
    @bid.price = @bargain.price # fix bid price as user offered one
    @tender = @bargain.tender
    @bid.bargain = @bargain
    @bid.tender = @tender
    @bid.dealer = current_dealer
    # @tender.submit_final!

    begin
      @bid.tender.take!
    rescue StateMachine::InvalidTransition => e
      flash[:warning] = e.to_s
      Rails.logger.info(e)
      redirect_to(tenders_path) and return
    end

    respond_to do |format|
      if @bid.save
        format.html { redirect_to @bid, notice: 'Bid was successfully created.' }
        format.json { render :show, status: :created, location: @bid }
      else
        format.html { render :new }
        format.json { render json: @bid.errors, status: :unprocessable_entity }
      end
    end
  end

  # def accept
  #   begin
  #     @deal = @bid.build_deal(final_price: @bid.price, postscript: @bid.description)
  #     @deal.tender = @bid.tender
  #     @deal.dealer = @bid.dealer
  #     @deal.user = current_user
  #     @bid.tender.make_deal!
  #   rescue StateMachine::InvalidTransition => e
  #     flash[:warning] = e.to_s
  #     Rails.logger.info(e)
  #     redirect_to(tenders_path) and return
  #   end
  #   respond_to do |format|
  #     if @deal.save!
  #       format.html { redirect_to deals_path, notice: 'Bid was successfully accepted.' }
  #       format.json { render :show_deal, status: :created, location: @deal }
  #     else
  #       format.html { redirect_to(tenders_path) }
  #       format.json { render json: @deal.errors, status: :unprocessable_entity }
  #     end
  #   end
  # end

  ## automatically accepted
  # def accept_final
  #   begin
  #     @deal = @bid.build_deal(final_price: @bid.price, postscript: @bid.description, verify_code: Deal.gen_verify_code)
  #     @deal.tender = @bid.tender
  #     @deal.dealer = @bid.dealer
  #     @deal.user = current_user
  #     @bid.tender.accept_price!
  #   rescue StateMachine::InvalidTransition => e
  #     flash[:warning] = e.to_s
  #     Rails.logger.info(e)
  #     redirect_to(tenders_path) and return
  #   end
  #   respond_to do |format|
  #     if @deal.save!
  #       format.html { redirect_to tender_path(@bid.tender), notice: 'Bid was successfully accepted.' }
  #       format.json { render :show_deal, status: :created, location: @deal }
  #     else
  #       format.html { redirect_to(tenders_path) }
  #       format.json { render json: @deal.errors, status: :unprocessable_entity }
  #     end
  #   end
  # end

private

  def create_params
    params[:bid].require(:bargain_id)
    params.require(:bid).permit(:bargain_id)
  end

  def update_params
    params.require(:bid).permit(:insurance,
                                # :vehicle_tax,
                                :purchase_tax,
                                :license_fee,
                                :misc_fee,
                                :description)
  end

  def set_bid
    @bid = Bid.find(params[:id])
  end

end
