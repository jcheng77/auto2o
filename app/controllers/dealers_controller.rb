class DealersController < ApplicationController


  before_action :authenticate_user!

  def index
    @dealers = Dealer.all
  end

  def show
  end



end
