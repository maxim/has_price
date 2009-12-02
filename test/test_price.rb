require 'helper'

class TestPrice < Test::Unit::TestCase
  context "Price instance" do
    setup do
      @price = Price[{ "base" => 100, 
                       "tax" => 10, 
                       "delivery" => { "shipping" => 20, 
                                       "expedite" => 5, 
                                       "discounts" => { "thanksgiving" => -20 }}}]
    end

    should "calculate total recursively" do
      assert_equal 115, @price.total
    end
    
    should "return total on to_i" do
      assert_equal 115, @price.to_i
    end
    
    should "return Hash on to_hash" do
      assert_equal Hash, @price.to_hash.class
    end
    
    should "support equality with the equivalent hash" do
      assert_equal @price, @price.to_hash
    end
    
    should "access hash values with missing methods" do
      assert_equal 10, @price.tax
    end
    
    should "return Price object upon accessing nested group" do
      assert_equal Price, @price.delivery.class
    end
    
    should "return equivalent of sub-hash as nested group" do
      assert_equal({"shipping" => 20, "expedite" => 5, "discounts" => { "thanksgiving" => -20 }}, @price.delivery)
    end
    
    should "return subtotal of a nested group" do
      assert_equal 5, @price.delivery.total
    end
    
    should "support deep chaining for accessing groups" do
      assert_equal({"thanksgiving" => -20}, @price.delivery.discounts)
    end
    
    should "provide subtotal on deep nested group with single element" do
      assert_equal -20, @price.delivery.discounts.total
    end
    
    should "access individual elements in deep nested groups" do
      assert_equal -20, @price.delivery.discounts.thanksgiving
    end
    
    should "raise NoMethodError in case called non-existent item/group" do
      assert_raise NoMethodError do
        @price.foo
      end
    end
  end
end
