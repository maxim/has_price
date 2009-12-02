module HasPrice
  class Price < Hash
    # @return [Fixnum] the recursive sum of all declared prices.
    def to_i; recursive_sum end
    # @return [String] the output of to_i converted to string.
    def to_s; to_i.to_s end
    # @return [Hash] the price as a Hash object.
    def to_hash; Hash[self] end
    alias total to_i
    
    # Provides access to price items and groups using magic methods and chaining.
    #
    # @example
    #   class Product
    #     has_price do
    #       item 400, "base"
    #       group "tax" do
    #         item 100, "federal"
    #         item 50, "state"
    #       end
    #     end
    #   end
    #
    #   product = Product.new
    #   product.price # => Full Price object
    #   product.price.base # => 400
    #   product.price.tax # => Price object on group tax
    #   product.price.tax.federal # => 100
    #   product.price.tax.total # => 150
    #
    # @return [Price, Fixnum] Price object if method matches a group, Fixnum if method matches an item.
    def method_missing(meth, *args, &blk)
      value = select{|k,v| k.underscore == meth.to_s}.first
      
      if !value
        super
      elsif value.last.is_a?(Hash)
        self.class[value.last]
      else
        value.last
      end
    end
    
  private
    def recursive_sum(target = self)
      target.inject(0) do |sum, pair|
        value = pair.last
        sum += value.is_a?(Hash) ? recursive_sum(value) : value
      end 
    end
  end
end