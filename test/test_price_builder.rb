require 'helper'

class TestPriceBuilder < Test::Unit::TestCase
  context "PriceBuilder" do
    context "instance" do
      setup do
        @instance = Object.new
        @price_builder = PriceBuilder.new(@instance)
      end
      
      should "create an item in price hash" do
        @price_builder.item 500, "base"
        assert_equal({"base" => 500}, @price_builder.price)
      end
      
      should "create an item based on another price" do
        tax_price = Price[{"federal" => 100, "state" => 200}]
        @price_builder.item tax_price, "tax"
        assert_equal({"tax" => {"federal" => 100, "state" => 200}}, @price_builder.price)
      end
      
      should "create a group in price hash" do
        @price_builder.group "taxes"
        assert_equal({"taxes" => {}}, @price_builder.price)
      end
      
      should "create an item in a group in a price hash" do
        @price_builder.group "taxes" do
          item 500, "federal tax"
        end
        
        assert_equal({"taxes" => {"federal tax" => 500}}, @price_builder.price)
      end
      
      should "support complex group structure" do
        @price_builder.item 500, "base"
        @price_builder.group "delivery" do
          item 200, "standard shipping"
          
          group "discounts" do
            item -100, "shipping discount"
          end
          
          item 100, "expedite"
        end
        
        assert_equal({"base" => 500, "delivery" => { "standard shipping" => 200, 
                                                     "expedite" => 100,
                                                     "discounts" => { "shipping discount" => -100 }
                                                    }}, @price_builder.price)
      end
      
      should "send all missing methods to the object" do
        stub(@instance).base_price { 200 }
        assert_equal 200, @price_builder.base_price
      end
    end
  end
end
