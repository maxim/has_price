require 'helper'

class TestHasPrice < Test::Unit::TestCase
  context "A Product with HasPrice module" do
    setup do
      Product = Class.new
      Product.extend(HasPrice)
    end

    context "having price defined as :free" do
      setup do
        Product.has_price :free => true
        @product = Product.new
      end
      
      should "gain #price method" do
        assert Product.instance_methods.include? "price"
      end
      
      should "return empty Price object" do
        assert_equal Price.new, @product.price
      end
    end
    
    context "having price defined using builder with hardcoded values" do
      setup do
        Product.has_price do
          item 100, "base"
          group "tax" do
            item 20, "federal"
            item 10, "state"
          end
        end
        
        @product = Product.new
      end
      
      should "gain #price method" do
        assert Product.instance_methods.include? "price"
      end
      
      should "return price object" do
        assert_equal Price, @product.price.class
      end
      
      should "return price equivalent to corresponding hash" do
        assert_equal({"base" => 100, "tax" => {"federal" => 20, "state" => 10}}, @product.price)
      end
    end
    
    context "having price defined using builder with values referencing product methods" do
      setup do
        Product.has_price do
          item base_price, "base"
          group "tax" do
            item federal_tax, "federal"
          end
        end
        
        @product = Product.new
        
        mock(@product).base_price { 100 }
        mock(@product).federal_tax { 20 }
      end
      
      should "return Price object with values correctly set from instance methods" do
        assert_equal({"base" => 100, "tax" => {"federal" => 20}}, @product.price)
      end
    end
    
    context "having price defined on attribute total_price" do
      setup do
        Product.has_price :attribute => "total_price", :free => true
      end
      
      should "gain #total_price method" do
        assert Product.instance_methods.include? "total_price"
      end
    end
  end
  
  def teardown
    self.class.instance_eval { remove_const :Product }
  end
end
