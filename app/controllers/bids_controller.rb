class BidsController < InheritedResources::Base

  before_action :authenticate_dealer!

  def index
    @bids = current_dealer.bids.all
  end

end
