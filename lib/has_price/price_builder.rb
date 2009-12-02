module HasPrice
  class PriceBuilder
    attr_reader :price
    
    # Creates PriceBuilder on a target object.
    #
    # @param [Object] object the target object on which price is being built.
    def initialize(object)
      @price = Price.new
      @current_nesting_level = @price
      @object = object
    end
  
    # Adds price item to the current nesting level of price definition.
    #
    # @param [#to_hash, #to_i] price an integer representing amount for this price item.
    #   Alternatively, anything that responds to #to_hash can be used, 
    #   and will be treated as a group named with item_name.
    # @param [#to_s] item_name name for the provided price item or group.
    #
    # @see #group
    def item(price, item_name)
      @current_nesting_level[item_name.to_s] = price.respond_to?(:to_hash) ? price.to_hash : price.to_i
    end
  
    # Adds price group to the current nesting level of price definition.
    # Groups are useful for price breakdown categorization and easy subtotal values. 
    #
    # @example Using group subtotals
    #   class Product
    #     include HasPrice
    #
    #     def base_price; 100 end
    #     def federal_tax; 15 end
    #     def state_tax; 10 end
    #
    #     has_price do
    #       item base_price, "base"
    #       group "tax" do
    #         item federal_tax, "federal"
    #         item state_tax, "state"
    #       end
    #     end
    #   end
    #
    #   @product = Product.new
    #   @product.price.total # => 125
    #   @product.price.tax.total # => 25
    #
    # @param [#to_s] group_name a name for the price group
    # @yield The yielded block is executed within the group, such that all groups and items
    #   declared within the block appear nested under this group. This behavior is recursive.
    #
    # @see #item
    def group(group_name, &block)
      group_key = group_name.to_s
      
      @current_nesting_level[group_key] ||= {}
      
      if block_given?
        within_group(group_key) do
          instance_eval &block
        end
      end
    end
    
    # Delegates all missing methods to the target object.
    def method_missing(meth, *args, &block)
      @object.send(meth, *args, &block)
    end

  private
    def within_group(group_name)
      step_into group_name
      yield
      step_out
    end
    
    def step_into(group_name)
      @original_nesting_level = @current_nesting_level
      @current_nesting_level = @current_nesting_level[group_name]
    end
    
    def step_out
      @current_nesting_level = @original_nesting_level
    end
  end
end