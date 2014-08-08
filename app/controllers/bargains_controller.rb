class BargainsController < InheritedResources::Base
  
  
  before_action :set_bargin, only: [:show, :edit, :update, :destroy, :accept]
  
  
  
  def accept
    @deal = @bargin.tender.build_deal(final_price: @bargin.price, postscript: @bargin.postscript)
    @deal.save!
    redirect_to deals_path
  end
  
  
private
  
  # Use callbacks to share common setup or constraints between actions.
  def set_bargin
    @bargin = Bargain.find(params[:id])
  end  
  
  def bargain_params
    params.require(:bargain).permit(:price, :postscript)
  end
  
  
end
