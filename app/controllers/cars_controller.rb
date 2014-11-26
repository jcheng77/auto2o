class CarsController < ApplicationController


  def brands
    @car_brands = Car::Brand.all
  end


  def list
    str = ''
    pic_data = JSON.parse(File.read('/Users/swang/Projects/ruby_scripts/cars_pics_output'))

    @car_brands = Car::Brand.includes(:makers, :trims, :shops, models: [:pics, :colors]).all

    @cars = { 'brands' => [] }

    @car_brands.each do |car_brand|

      brand = { id: car_brand.id, 'name' => car_brand.name, 'makers' => [] }

      car_brand.makers.each  do |car_maker|

        maker = { id: car_maker.id, 'name' => car_maker.name, 'models' => [] }

        car_maker.models.each do |car_model|

          next if maker['models'].index { |model| model['name'] == car_model.name }

          model = { id: car_model.id, 'name' => car_model.name, 'pic_url' => car_model.pics[0].pic_url, 'trims' => [], 'colors' => [], 'shops' => []}

          #model_name = (model['name'].include?brand['name']) ? model['name'].delete(brand['name']) : model['name']
          model_name = model['name']
          others = model_name[/([\(|（].+[\)|）])/u,1]
          model_name.delete!(others) unless others == nil
          model_name.strip!
          if pic_data['Cars'].include? brand['name']
            pic_data['Cars'][brand['name']].keys.each do |key|
              if key.include? model_name
                model['pic_url'] = pic_data['Cars'][brand['name']][key]
              end
            end
          end
          str << "#{model_name}:#{others}:#{model['pic_url']}\n" 

          car_model.trims.each do |car_trim|
            lowest_price = Car::Price.where(:trim_id => car_trim.id).first #.order('offering_date desc').first
            model['trims'] << { 'id' => car_trim.id, 'name' => car_trim.name, 'guide_price' => car_trim.guide_price, 'lowest_price' => lowest_price == nil ? -1 : lowest_price.price }
          end

          car_model.colors.each do |car_color|
            model['colors'] << { id: car_color.id, 'name' => car_color.name, 'code' => car_color.code }
          end

          car_model.shops.each do |shop|
             model['shops'] << { id: shop.id, name: shop.name, address: shop.address } 
          end

          maker['models'] << model
        end

        brand['makers'] << maker
      end
      @cars['brands'] << brand
    end

    File.open('data/models_without_pic','w+') { |file| file.write(str) }

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

  def self.bulk_import_cars
    Shop       .delete_all
    Car::Price .delete_all
    Car::Color .delete_all
    Car::Trim  .delete_all
    Car::Pic   .delete_all
    Car::Model .delete_all
    Car::Maker .delete_all
    Car::Brand .delete_all
    Dir.foreach('data') do |file|
      if file =~ /cars_info/
        import_cars('data/' + file)
      end
    end
  end

  def self.import_cars(file='data/cars_info_3')
    data = JSON.parse(File.read(file))
    return if data == []
    brands = {}
    makers = {}
    models = {}
    data.map do |car|
      unless brand = brands[car['@brand']]
        brand = Car::Brand.find_or_create_by(name: car['@brand'])
        brands[car['@brand']] = brand
      end
      unless maker = makers[car['@make']]
        maker = Car::Maker.find_or_create_by(name: car['@make'], brand: brand)
        makers[car['@make']] = maker
      end
      unless car_model = models[car['@model']]
        car_model = Car::Model.find_or_create_by(name: car['@model'], maker: maker)
        models[car['@model']] = car_model
      end
      car_pic = Car::Pic.find_or_create_by(pic_url: car['@icon_link'], model: car_model)
      car_trims = []
      car['@trims'].map do |trim|
        car_trim = Car::Trim.find_or_create_by(name: trim['@trim_name'], model: car_model)
        car_trim.guide_price = trim['@guide_price']
        car_trim.prices << Car::Price.find_or_create_by(offering_date: trim['@price']['@date'], price: trim['@price']['@lowest_price'], trim_id: car_trim.id)
        car_trim.save!
        car_trims << car_trim
      end
      car_colors = []
      car['@colors'].map do |color|
        car_colors << Car::Color.find_or_create_by(name: color['@color_name'], code: color['@color_code'], model: car_model)
      end
      car_shops = []
      car['@dealers'].map do |dealer|
        car_shop = Shop.find_or_create_by(name: dealer['@name'])
        car_shop.address = dealer['@address']
        car_shop.save!
        car_shops << car_shop
      end
      car_model.pics << car_pic
      car_model.trims = car_trims
      car_model.colors = car_colors
      car_model.shops = car_shops
      maker.models << car_model
      brand.makers << maker
    end
  end

end
