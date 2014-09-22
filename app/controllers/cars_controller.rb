class CarsController < ApplicationController


  def brands
    @car_brands = Car::Brand.all
  end


  def list
    @car_brands = Car::Brand.all

    @cars = { 'brands' => [] }

    @car_brands.each do |car_brand|

      brand = { 'name' => car_brand.name, 'makers' => [] }

      car_brand.makers.each  do |car_maker|

        maker = { 'name' => car_maker.name, 'models' => [] }

        car_maker.models.each do |car_model|

          next if maker['models'].index { |model| model['name'] == car_model.name }

          model = { 'name' => car_model.name, 'pic_url' => car_model.pics[0].pic_url, 'trims' => [], 'colors' => [] }
          car_model.trims.each do |car_trim|
            model['trims'] << { 'id' => car_trim.id, 'name' => car_trim.name, 'guide_price' => car_trim.guide_price }
          end

          car_model.colors.each do |car_color|
            model['colors'] << { 'name' => car_color.name, 'code' => car_color.code }
          end

          maker['models'] << model
        end

        brand['makers'] << maker
      end
      @cars['brands'] << brand
    end

    respond_to do |format|
      format.html { render index.html.erb }
      format.xml  { render xml: @cars }
      format.json { render json: @cars }
    end
  end

  def trims
    @models = Car::Model.find_by(id: params['model_id'])
    @trims = @models.trims

    respond_to do |format|
      #format.html index.html.erb
      format.xml  { render xml: @trims }
      format.json { render json: @trims }
    end
  end

  def self.import_cars(file='cars_audi')

    Car::Color .delete_all
    Car::Trim  .delete_all
    Car::Pic   .delete_all
    Car::Model .delete_all
    Car::Maker .delete_all
    Car::Brand .delete_all

    data = JSON.parse(File.read(file))

    brands = {}
    makers = {}
    models = {}
    data["Cars"].map do |car|
      unless brand = brands[car['@brand']]
        brand = Car::Brand.find_or_create_by(name: car['@brand'])
        brands[car['@brand']] = brand
      end
      unless maker = makers[car['@make'][/(.+)\(/,1]]
        maker = Car::Maker.find_or_create_by(name: car['@make'][/(.+)\(/,1], brand: brand)
        makers[car['@make'][/(.+)\(/,1]] = maker
      end
      unless car_model = models[car['@model'][/(.+)\(/,1]]
        car_model = Car::Model.find_or_create_by(name: car['@model'][/(.+)\(/,1], maker: maker, year: car['@year'])
        models[car['@model'][/(.+)\(/,1]] = car_model
      end
      car_pic = Car::Pic.find_or_create_by(pic_url: car['@icon_link'], model: car_model)
      car_trims = []
      car['@trims'].map do |trim|
        car_trims << Car::Trim.find_or_create_by(name: trim['@trim_name'], model: car_model)
      end
      car_colors = []
      car['@colors'].map do |color|
        car_colors << Car::Color.find_or_create_by(name: color['@color_name'], code: color['@color_code'], model: car_model)
      end
      car_model.pics   << car_pic
      car_model.trims   = car_trims
      car_model.colors  = car_colors
      maker.models << car_model
      brand.makers << maker
    end
  end

end
