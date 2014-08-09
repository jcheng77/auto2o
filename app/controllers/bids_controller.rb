class BidsController < InheritedResources::Base

    before_action :authenticate_dealer!

  def index
    @bids = Bid.all
  end

end
