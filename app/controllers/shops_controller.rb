class ShopsController < InheritedResources::Base

  before_action :set_shop, except: [:index, :create, :new]

  def index
    @shops = Shop.all
  end

  def show
  end

private

  def shop_params
    params.require(:shop).permit(:name)
  end

  def set_shop
    @shop = Shop.find(params[:id])
  end

end
