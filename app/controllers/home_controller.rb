class HomeController < ApplicationController
  def index
    flash.now[:success] = 'success'
    flash.now[:info] = 'info'
    flash.now[:warning] = 'warning'
    flash.now[:danger] = 'danger'

    @brands = Car::Brand.all
    @brands.each do |brand|
      logger.debug brand.name
      brand.name.encode!('gbk','utf-8')
    end
    @brands = @brands.sort_by &:name 
    @brands.each do |brand|
      brand.name.encode!('utf-8','gbk')
      logger.debug brand.name
    end

    @models = Car::Model.all
    respond_to do |format|
      format.html
      format.json
      format.svg  { render :qrcode => root_url, :level => :l, :unit => 10 }
      format.png  { render :qrcode => root_url }
      format.gif  { render :qrcode => root_url }
      format.jpeg { render :qrcode => root_url }
    end
  end

  def introduction
  end

  def download
    respond_to do |format|
      format.html
      format.json
      format.png  { render :qrcode => 'http://zhushou.360.cn/detail/index/soft_id/2326532' }
      format.jpeg { render :qrcode => 'http://shouji.360tpcdn.com/141114/3e7a9e0064a93b68e2f486a4b6b5161a/com.cettco.buycar_1.apk'}
    end
  end

  def about
    respond_to do |format|
      format.html {}
    end
  end

  def join
    respond_to do |format|
      format.html {}
    end
  end

end
