class ShopsController < InheritedResources::Base

  before_action :set_shop, except: [:index, :create, :new]

  def index
    if params[:trim_id]
      @shops = Car::Trim.find(params[:trim_id]).brand.shops
      respond_to do |format|
        format.html
        format.json
      end
    end
  end

  def show
    @comments = @shop.comments
  end

private

  def shop_params
    params.require(:shop).permit(:name)
  end

  def set_shop
    @shop = Shop.find(params[:id])
  end

end
