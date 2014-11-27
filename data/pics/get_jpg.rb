pic_str = File.read('/Users/swang/Projects/ruby_scripts/cars_pics_output')
pic_str.scan(/http:\/\/img.+?jpg/).each do |url|
	`wget "#{url}"`
end
