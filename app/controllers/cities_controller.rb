class CitiesController < InheritedResources::Base



  def show
    @city = City.find(params[:id])
    @shops = @city.shops
    super
  end


end

