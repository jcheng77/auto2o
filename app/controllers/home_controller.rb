class HomeController < ApplicationController
  def index
    flash.now[:success] = 'success'
    flash.now[:info] = 'info'
    flash.now[:warning] = 'warning'
    flash.now[:danger] = 'danger'

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
      format.png  { render :qrcode => 'http://openbox.mobilem.360.cn/index/d/sid/2326532' }
      format.jpeg { render :qrcode => 'http://openbox.mobilem.360.cn/index/d/sid/2326532'}
    end
  end

end
