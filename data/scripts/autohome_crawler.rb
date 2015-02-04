#encoding: utf-8

require 'json'
require 'watir-webdriver'
require 'selenium-webdriver'
require 'headless'

module JSONable
	def to_json(options = {})
		hash = {}
		self.instance_variables.each do |var|
			hash[var] = self.instance_variable_get var
		end
		hash.to_json
	end
	def from_json! string
		JSON.load(string).each do |var, val|
			self.instance_variable_set var, val
		end
	end
end

class Car 
	include JSONable
	attr_accessor :brand, :make, :model, :year, :icon_link, :trims, :colors, :dealers
	def initialize(brand, make, model, year='', icon_link='', trims=[], colors=[], dealers=[])
		@brand = brand
		@make = make
		@model = model
		@year = year
		@icon_link = icon_link
		@trims = trims
		@colors = colors
		@dealers = dealers
	end
end

class Trim
	include JSONable
	attr_accessor :trim_name, :guide_price, :price
	def initialize(trim_name, guide_price, price)
		@trim_name = trim_name 
		@guide_price = guide_price
		@price = price
	end
end

class Color
	include JSONable
	attr_accessor :color_name, :color_code
	def initialize(color_name, color_code)
		@color_name = color_name
		@color_code = color_code
	end
end

class Price
	include JSONable
	attr_accessor :date, :lowest_price
	def initialize(date, lowest_price)
		@date = date
		@lowest_price = lowest_price
	end
end

class Dealer
	include JSONable
	attr_accessor :name, :address, :city
	def initialize (name, address, city)
		@name = name
		@address = address
		@city = city
	end
end

class AutohomeCrawler

	def headless_mode
		headless = Headless.new
		headless.start
		Watir::browser.start 'www.baidu.com'
	end

	def firefox
		profile = Selenium::WebDriver::Firefox::Profile.new('/Users/swang/Library/Application Support/Firefox/Profiles/l741xo56.default')
		#profile.proxy = Selenium::WebDriver::Proxy.new #:http => 'proxy.successfactors.com:8080', :ssl => 'proxy.successfactors.com:8080'
		client = Selenium::WebDriver::Remote::Http::Default.new
		client.timeout = 3600
		Watir::Browser.new :firefox, :profile => profile, :http_client => client
	end

	def initialize(mode=:firefox)
		case mode
		when :headless
			@browser = headless_mode
		else 
			@browser = firefox 
		end
	end

	def crawl_brand_logo
		@browser.goto('http://car.autohome.com.cn/zhaoche/pinpai/?pvareaid=101451')
		pic_links = @browser.links(:class, 'pic')
		h = {}
		pic_links.each do |pic_link|
			name = pic_link.parent.parent.link(:index, 1).text
			url = pic_link.img(:index, 0).src
			h[name] = url
			`wget "#{url}"`
		end
		File.open('./car_brand_logo','w+') { |file| file.write(JSON.dump(h)) }
	end

	def crawl(n,m)
		begin
			pic_data = JSON.parse(File.read('/Users/swang/Projects/ruby_scripts/cars_pics_output'))
			#profile = Selenium::WebDriver::Firefox::Profile.new('C:\Users\I073308\AppData\Local\Mozilla\Firefox\Profiles\6z9xtohk.default')
			#@browser.driver.manage.timeouts.implicit_wait = 600
			base_url = 'http://car.autohome.com.cn/'
			#base_url = 'www.google.com'
			@browser.goto base_url
			brand_list = @browser.div(:id => 'cartree').lis.collect { |li| li.link(:index => 0).text[/(.+)\(/,1] }
			puts "Brand list #{brand_list.inspect}"
			#File.open('car_brand_list', 'w+') { |file| file.write(brand_list.join("\n")) }
			(n..m).each do |i|
				parse(brand_list,i-1,pic_data)
			end
		rescue => e
			puts "#{$!.class}\n#{$!}\n#{$@.join("\n")}"
		end
	end

	def parse(brand_list, brand_index, pic_data)
		begin
			cars = {'Cars' => []}
			# Enter Brand Page
			@browser.div(:id => 'cartree').link(:text => /#{brand_list[brand_index]}/).click
			models = []
			html = @browser.div(:id => 'cartree').link(:text => /#{brand_list[brand_index]}/).parent.parent.inner_html
			dt_dds_list = []
			offset = html.index('<dt>')
			while html.index('<dt>', offset+1) != nil
				dt_dds_list << html[offset..html.index('<dt>', offset+1)-1]
				offset = html.index('<dt>', offset+1)	
			end 
			dt_dds_list << html[offset..-1]
			model_ids = {}
			dt_dds_list.each do |item_dt_dds|
				maker_name = item_dt_dds[/<dt>(.+?)<\/dt>/, 1][/<\/i>(.+?)<\/a>/, 1].strip
				dds = item_dt_dds.scan(/<dd>(.+?)<\/dd>/)
				dds.each do |dd|
					model_ids[maker_name] ||= [] 
					#model_ids[maker_name] << dd[0][/>(.+?)<em>/, 1].chomp(" ")
					model_ids[maker_name] << dd[0][/id="(.+?)"/, 1]
				end
			end		
			model_ids.each do |maker_name, model_id_list|
				model_id_list.each do |model_id|
					# Enter Car Model Page
					next if @browser.div(:id => 'cartree').link(:id, model_id).text.include? '停售'
					@browser.div(:id => 'cartree').link(:id, model_id).click
					next unless @browser.div(:class, 'tab-nav border-t-no').li(:class, 'current').a(:index, 0).text.include? '在售'
					@browser.driver.execute_script("window.scrollBy(0,10000)")
					next if @browser.div(:text, '本城市(区/县)暂无经销商促销信息').exist?
					model_name = @browser.div(:id => 'cartree').link(:id, model_id).text[/(.+)\(?/, 1].strip
					puts model_name
					car = Car.new(brand_list[brand_index], maker_name, model_name)
					# Get Car Pics
					if pic_data['Cars'].include? car.brand
						pic_data['Cars'][car.brand].keys.each do |key|
						 	if key.include? car.model
								car.icon_link = pic_data['Cars'][car.brand][car.model]
							end
						end
					end
					# Get Car Color
					color_link_list = []
					if @browser.li(:class, 'lever-ul-color').div(:class, /carcolor/).exist?
						if @browser.span(:text, /更多颜色/).exist?
							@browser.span(:text, /更多颜色/).click
							color_link_list = @browser.div(:id, /carColor/).links
						else
							color_link_list = @browser.li(:class, 'lever-ul-color').div(:class, 'carcolor').links
						end
						raise "No Color has been found for #{brand_list[brand_index]} #{maker_name} #{model_name}!" if color_link_list == []
						color_link_list.each do |color_link|
							color_name = color_link.div(:class, 'tip-content').html[/>(.+)</, 1].strip
							color_code = color_link.inner_html[/background:(.+);/, 1]
							color_code == nil ? '' : color_code.strip 
							color = Color.new(color_name, color_code)
							puts color.inspect
							car.colors << color	
						end
					else
						car.colors << Color.new('没有颜色选择','#FFFFFF')
					end
					# Get Car Trim
					trim_name_div_list = @browser.divs(:class, 'interval01-list-cars')
					trim_name_div_list.each do |trim_name_div|
						next unless trim_name_div.link(:index => 0).exist? 
						#puts trim_name_div.html
						trim_name = trim_name_div.link(:index => 0).text.strip
						year = trim_name[/(\d+)款/, 1]
						car.year = year.to_s if car.year == ''
						guide_price = trim_name_div.parent.span(:class, 'guidance-price').text
						guide_price = (guide_price == '暂无报价') ? -1 : guide_price[/(.+)万/,1]
						lowest_price = trim_name_div.parent.span(:class, 'lowest-price').text
						lowest_price = (lowest_price == '暂无报价') ? -1 : lowest_price[/(.+)万/,1]
						price = Price.new(Time.now.strftime('%Y-%m-%d'), lowest_price)
						trim = Trim.new(trim_name, guide_price, price)
						puts trim.inspect
						car.trims << trim 
					end
					# Get Dealers
					isDone = true
					begin 
						Watir::Wait.until { @browser.div(:id, 'dealerlist').divs(:class, 'sale-cont').size != 0 }
						@browser.div(:id, 'dealerlist').divs(:class, 'sale-cont').each do |dealer_div|
							#puts dealer_div.html
							dealer_name = dealer_div.div(:class, 'name-title').link(:index => 0).text.strip
							dealer_address = dealer_div.span(:class, 'name-add').text
							dealer_city = dealer_div.li(:class, 'sale-cont-add').p(:index => 0).text
							dealer = Dealer.new(dealer_name, dealer_address, dealer_city)
							puts dealer.inspect
							car.dealers << dealer
						end
						break unless @browser.div(:class, 'js-page page').exist?
						if @browser.div(:class, 'js-page page').a(:class, /page-item-next/).exist?
							isDone = false
							@browser.div(:class, 'js-page page').a(:class, /page-item-next/).click
						else
							isDone = true
						end
					end until isDone 
					puts car.inspect
					cars << car
				end
			end
		rescue => e
			raise e
		ensure
			json = JSON.dump(cars)
			File.open("cars_info_#{brand_index}", 'w+') { |file| file.write(json) }
		end
	end
end

AutohomeCrawler.new.crawl(1,2)

