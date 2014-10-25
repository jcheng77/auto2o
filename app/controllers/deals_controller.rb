class DealsController < InheritedResources::Base

  before_action :authenticate_user!, only: [:index, :qrcode, :show]

  before_action :authenticate_dealer!, only: [:verify]

  before_action :set_deal, except: [:index, :create, :new]

  def index
    @deals = current_user.deals.all
  end

  def show
    @tender = @deal.tender
    @bid = @deal.bid
  end

  def show_for_dealer
    @tender = @deal.tender
    @bid = @deal.bid
  end

  def qrcode
    respond_to do |format|
      format.html
      format.svg  { render :qrcode => verify_deal_url(@deal, code: @deal.verify_code), :level => :l, :unit => 10 }
      format.png  { render :qrcode => verify_deal_url(@deal, code: @deal.verify_code) }
      format.gif  { render :qrcode => verify_deal_url(@deal, code: @deal.verify_code) }
      format.jpeg { render :qrcode => verify_deal_url(@deal, code: @deal.verify_code) }
    end
  end

  def verify
    if @deal.dealer != current_dealer
      respond_to do |format|
        format.html { redirect_to root_url, notice: '验证码只能在成交商家使用.' }
        format.json { render json: {error: '验证码只能在成交商家使用'}, status: :unprocessable_entity }
      end
      return
    end
    if @deal.verify_code != params[:code]
      respond_to do |format|
        format.html { redirect_to @deal, notice: '验证码错误.' }
        format.json { render json: {error: '验证码错误'}, status: :unprocessable_entity }
      end
      return
    end
    begin
      @deal.do_verify! if @deal.verify_code == params[:code]
      @deal.tender.make_final_deal!
      respond_to do |format|
        format.html { redirect_to @deal, notice: '成功验证' }
        format.json { render json: {info: '成功验证'}, status: :ok, location: @deal }
      end
    rescue
      respond_to do |format|
        format.html { redirect_to @deal, notice: '状态错误' }
        format.json { render json: {error: '状态错误'}, status: :unprocessable_entity }
      end
    end
  end


private

  def set_deal
    @deal = Deal.find(params[:id])
  end

end
