require File.dirname(__FILE__) + "/has_price/core_extensions/array.rb"
require File.dirname(__FILE__) + "/has_price/core_extensions/string.rb"

unless Array.instance_methods.include? "extract_options!"
  Array.send :include, HasPrice::CoreExtensions::Array
end

unless String.instance_methods.include? "underscore"
  String.send :include, HasPrice::CoreExtensions::String
end

require File.dirname(__FILE__) + "/has_price/price.rb"
require File.dirname(__FILE__) + "/has_price/price_builder.rb"
require File.dirname(__FILE__) + "/has_price/has_price.rb"