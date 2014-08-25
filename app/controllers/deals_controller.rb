class DealsController < InheritedResources::Base

  before_action :authenticate_user!

  def index
    @deals = current_user.deals.all
  end

  def cancel

  end




end
