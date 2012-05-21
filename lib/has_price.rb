unless Kernel.respond_to?(:require_relative)
  module Kernel
    def require_relative(path)
      require File.join(File.dirname(caller[0]), path.to_str)
    end
  end
end

require_relative 'has_price/core_extensions/array.rb'
require_relative 'has_price/core_extensions/string.rb'

unless Array.respond_to?(:extract_options!)
  class Array
    include HasPrice::CoreExtensions::Array
  end
end

unless String.respond_to?(:underscore)
  class String
    include HasPrice::CoreExtensions::String
  end
end

require_relative 'has_price/price.rb'
require_relative 'has_price/price_builder.rb'
require_relative 'has_price/has_price.rb'

require_relative 'has_price/railtie' if defined?(Rails)
