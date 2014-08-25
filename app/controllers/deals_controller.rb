class DealsController < InheritedResources::Base

  before_action :authenticate_user!

  before_action :set_deal, except: [:index, :create, :new]

  def index
    @deals = current_user.deals.all
  end

  def show
    @tender = @deal.tender
  end

  def qrcode
    respond_to do |format|
      format.html
      format.svg  { render :qrcode => deal_path(@deal), :level => :l, :unit => 10 }
      format.png  { render :qrcode => deal_path(@deal) }
      format.gif  { render :qrcode => deal_path(@deal) }
      format.jpeg { render :qrcode => deal_path(@deal) }
    end
  end


  def cancel

  end


private

  def set_deal
    @deal = Deal.find(params[:id])
  end

end
