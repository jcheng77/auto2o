class HomeController < ApplicationController
  def index
    flash.now[:success] = 'success'
    flash.now[:info] = 'info'
    flash.now[:warning] = 'warning'
    flash.now[:danger] = 'danger'
  end
end
