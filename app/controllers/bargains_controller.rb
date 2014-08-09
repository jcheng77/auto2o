class BargainsController < InheritedResources::Base


  before_action :authenticate_user!

  before_action :set_bargin, only: [:show, :edit, :update, :destroy, :accept, :submit]

  def accept
    @deal = @bargin.tender.build_deal(final_price: @bargin.price, postscript: @bargin.postscript)
    @deal.save!
    redirect_to deals_path
  end


  def submit
    @bid = Bid.new(bid_params)
    @bid.bargain = @bargain
    @bid.tender = @bargain.tender
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


private

  # Use callbacks to share common setup or constraints between actions.
  def set_bargin
    @bargin = Bargain.find(params[:id])
  end

  def bargain_params
    params.require(:bargain).permit(:price, :postscript)
  end

  def bid_params
    params.require(:bid).permit(:price, :description)
  end

end
