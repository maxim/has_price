module HasPrice
  module HasPrice
    
    # Provides a simple DSL to defines price instance method on the receiver.
    #
    # @param [Hash] options the options for creating price method.
    # @option options [Symbol] :attribute (:price) Name of the price method.
    # @option options [Boolean] :free (false) Set `:free => true` to use null object pattern.
    #
    # @yield The yielded block provides method `item` for declaring price entries, 
    #   and method `group` for declaring price groups.
    #
    # @example Normal usage
    #   class Product < ActiveRecord::Base
    #     has_price do
    #       item base_price, "base"
    #       item discount, "discount"
    # 
    #       group "taxes" do
    #         item federal_tax, "federal tax"
    #         item state_tax, "state tax"
    #       end
    #
    #       group "shipment" do
    #         # Notice that delivery_method is an instance method.
    #         # You can call instance methods anywhere in has_price block.
    #         item delivery_price, delivery_method
    #       end
    #     end
    #   end
    # 
    # @example Null object pattern
    #   class Product < ActiveRecord::Base
    #     # Creates method #price which returns empty Price.
    #     has_price :free => true
    #   end
    #
    # @see PriceBuilder#item
    # @see PriceBuilder#group
    #
    def has_price(options = {}, &block)
      attribute = options[:attribute] || :price
      free = !block_given? && options[:free]
    
      define_method attribute.to_sym do
        builder = PriceBuilder.new self
        builder.instance_eval &block unless free
        builder.price
      end
    end
  end
end