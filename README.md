has_price
=========

Let's just say, it organizes your price breakdowns and allows for easy retrieval of price subgroups and subtotals, as well as simple serialization for your receipts.

Install
-------

Make sure [gemcutter.org](http://gemcutter.org) is in your sources.

<pre>
  sudo gem install has_price
</pre>

In rails environment:
<pre>
  config.gem "has_price"
</pre>

For any generic Ruby class:
<pre>
  require 'has_price'
  include HasPrice::HasPrice
</pre>

P.S. Usage as Rails plugin is supported too, but gem is preferred.

Organize
--------

Say you have a Product class with some attributes which price depends on. For this example assume that base_price, federal_tax, and state_tax are integer attributes existing on Product model.

<pre lang="ruby">
  class Product < ActiveRecord::Base
    has_many :discounts
  end
</pre>

has_price provides a small DSL with two methods, `item` and `group`, to help you organize this.

<pre lang="ruby">
  class Product < ActiveRecord::Base
    has_many :discounts
    
    has_price do
      item base_price, "base"
      group "taxes" do
        item federal_tax, "federal"
        item state_tax, "state"
      end
      group "discounts" do
        discounts.each do |discount|
          item discount.amount, discount.title
        end
      end
    end
  end
</pre>

What we've done just now is — built instance method `price` on products. Now you can use it as so.

<pre lang="ruby">
  # Hypothetically all these numbers are coming from the above declared instance methods.
  
  product = Product.find(1)
  product.price               # => Price object
  product.price.total         # => 500
  product.price.base          # => 400
  product.price.taxes         # => Price object
  product.price.taxes.federal # => 100
  product.price.taxes.total   # => 200
  product.discounts.total     # => -100
</pre>

Serialize
---------

Price object actually inherits from a plain old Hash. Therefore, this will work:

<pre lang="ruby">
  class Receipt < ActiveRecord::Base
    serialize :price, Hash
  end
</pre>

Now passing the whole price breakdown into receipt is as simple as `receipt.price = product.price`.