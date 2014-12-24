class ShopsController < InheritedResources::Base

  before_action :set_shop, except: [:index, :create, :new]

  def index
    if params[:trim_id]
      car_trim  = Car::Trim.find(params[:trim_id])
      car_trim.update(view_count: rand(10)) unless car_trim.view_count.present?
      car_trim.increment!(:view_count)
      @shops = car_trim.model.shops
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
