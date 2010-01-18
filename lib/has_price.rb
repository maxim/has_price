require File.dirname(__FILE__) + "/has_price/core_extensions/array.rb"
require File.dirname(__FILE__) + "/has_price/core_extensions/string.rb"

unless ["extract_options!", :extract_options!].any?{|meth| Array.instance_methods.include?(meth)}
  Array.send :include, HasPrice::CoreExtensions::Array
end

unless ["underscore", :underscore].any?{|meth| String.instance_methods.include?(meth)}
  String.send :include, HasPrice::CoreExtensions::String
end

require File.dirname(__FILE__) + "/has_price/price.rb"
require File.dirname(__FILE__) + "/has_price/price_builder.rb"
require File.dirname(__FILE__) + "/has_price/has_price.rb"