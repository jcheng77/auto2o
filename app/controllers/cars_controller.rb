class CarsController < InheritedResources::Base
	def car_list
		@car_brands = CarBrand.all
		@cars = { 'brands' => [] }
		@car_brands.each do |car_brand|
			brand = { 'name' => car_brand.name, 'makers' => [] }
			car_brand.car_makers.each  do |car_maker|
				maker = { 'name' => car_maker.name, 'models' => [] }
				car_maker.car_models.each do |car_model|
					next if maker['models'].index { |model| model['name'] == car_model.name }
          model = { 'name' => car_model.name, 'pic_url' => car_model.car_pics[0].pic_url, 'trims' => [], 'colors' => [] }
          car_model.car_trims.each do |car_trim|
            model['trims'] << { 'name' => car_trim.name, 'guide_price' => car_trim.guide_price }
          end
          car_model.car_colors.each do |car_color|
            model['colors'] << { 'name' => car_color.name, 'code' => car_color.code }
          end
					maker['models'] << model
 				end
 				brand['makers'] << maker
 			end
 			@cars['brands'] << brand
		end

    respond_to do |format|
      #format.html index.html.erb
      format.xml  { render xml: @cars }
      format.json { render json: @cars }
    end
  end

  def car_trims
  	@models = CarModel.find_by(name: params['model_name'])
  	@trims = @models.car_trims

    respond_to do |format|
      #format.html index.html.erb
      format.xml  { render xml: @trims }
      format.json { render json: @trims }
    end  	
  end

  def self.import_cars
    CarColor.delete_all
    CarTrim.delete_all
    CarPic.delete_all
    CarModel.delete_all
    CarMaker.delete_all
    CarBrand.delete_all
    data = JSON.parse(File.read('cars_audi'))
    data["Cars"].map do |car|
      car_brand = CarBrand.find_or_create_by(:name => car['@brand'])
      car_maker = CarMaker.find_or_create_by(:name => car['@make'][/(.+)\(/,1], :car_brand => car_brand)
      car_model = CarModel.find_or_create_by(:name => car['@model'][/(.+)\(/,1], :car_maker => car_maker, :year => car['@year'])
      car_pic = CarPic.find_or_create_by(:pic_url => car['@icon_link'], :car_model => car_model)
      car_trims = []
      car['@trims'].map do |trim| 
        car_trims << CarTrim.find_or_create_by(:name => trim['@trim_name'], :car_model => car_model)
      end
      car_colors = []
      car['@colors'].map do |color|
        car_colors << CarColor.find_or_create_by(:name => color['@color_name'], :code => color['@color_code'], :car_model => car_model)
      end
      car_model.car_pics << car_pic 
      car_model.car_trims = car_trims
      car_model.car_colors = car_colors
      car_maker.car_models << car_model
      car_brand.car_makers << car_maker
    end
  end
  
end
