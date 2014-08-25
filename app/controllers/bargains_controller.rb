class BargainsController < InheritedResources::Base


  before_action :authenticate_user!
  before_action :authenticate_dealer!, only: [:submit]

  before_action :set_bargain, only: [:show, :edit, :update, :destroy, :submit]

  def submit
    @bid = Bid.new(bid_params)
    @tender = @bargain.tender
    @bid.bargain = @bargain
    @bid.tender = @tender
    @bid.dealer = current_dealer
    @tender.submit_final!
    respond_to do |format|
      if @bid.save
        format.html { redirect_to @tender, notice: 'Bid was successfully created.' }
        format.json { render :show, status: :created, location: @bid }
      else
        format.html { render :new }
        format.json { render json: @bid.errors, status: :unprocessable_entity }
      end
    end
  end

private

  # Use callbacks to share common setup or constraints between actions.
  def set_bargain
    @bargain = Bargain.find(params[:id])
  end

  def bargain_params
    params.require(:bargain).permit(:price, :postscript)
  end

  def bid_params
    params.require(:bid).permit(:price, :description)
  end

end
