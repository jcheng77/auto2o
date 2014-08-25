class BidsController < InheritedResources::Base

  before_action :authenticate_dealer!

  before_action :set_bid, except: [:index, :create, :new]

  def index
    @bids = current_dealer.bids.all
  end

  def accept
    begin
      @deal = @bid.build_deal(final_price: @bid.price, postscript: @bid.description)
      @deal.tender = @bid.tender
      @deal.dealer = @bid.dealer
      @deal.user = current_user
      @bid.tender.make_deal!
    rescue StateMachine::InvalidTransition => e
      flash[:warning] = e.to_s
      Rails.logger.info(e)
      redirect_to(tenders_path) and return
    end
    respond_to do |format|
      if @deal.save!
        format.html { redirect_to deals_path, notice: 'Bid was successfully accepted.' }
        format.json { render :show_deal, status: :created, location: @deal }
      else
        format.html { redirect_to(tenders_path) }
        format.json { render json: @deal.errors, status: :unprocessable_entity }
      end
    end
  end

  def accept_final
    begin
      @deal = @bid.build_deal(final_price: @bid.price, postscript: @bid.description)
      @deal.tender = @bid.tender
      @deal.dealer = @bid.dealer
      @deal.user = current_user
      @bid.tender.make_final_deal!
    rescue StateMachine::InvalidTransition => e
      flash[:warning] = e.to_s
      Rails.logger.info(e)
      redirect_to(tenders_path) and return
    end
    respond_to do |format|
      if @deal.save!
        format.html { redirect_to deals_path, notice: 'Bid was successfully accepted.' }
        format.json { render :show_deal, status: :created, location: @deal }
      else
        format.html { redirect_to(tenders_path) }
        format.json { render json: @deal.errors, status: :unprocessable_entity }
      end
    end
  end

private

  def set_bid
    @bid = Bid.find(params[:id])
  end

end
