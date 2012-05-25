has_price
=========

Let's just say, it organizes your price breakdowns and allows for easy retrieval of price subgroups and subtotals, as well as simple serialization for your receipts.

Install
-------

    gem install has_price

In Rails you will automatically get `has_price` in models. 
Everywhere else you would need to include it yourself.

```ruby
include HasPrice::HasPrice
```

Organize
--------

Say you have a Product class with some attributes which price depends on. For this example assume that `base_price`, `federal_tax`, and `state_tax` are integer attributes on a `Product` model.

```ruby
class Product < ActiveRecord::Base
  has_many :discounts
end
```

`has_price` provides a small DSL with two methods, `item` and `group`, to help you organize this.

```ruby
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
```

This builds an instance method `price` on products which returns a Hash-like structure with some extra features. Now you can use it as so.

```ruby
# Hypothetically, the actual numbers are stored in the aforementioned attributes on your model.
  
product = Product.find(1)
product.price               # => Price hash-like object
product.price.total         # => 500
product.price.base          # => 400
product.price.taxes         # => Price hash-like object
product.price.taxes.federal # => 50
product.price.taxes.total   # => 100
product.discounts.total     # => -50
```

Serialize
---------

Price object actually inherits from a plain old Hash. Therefore, serialization should work out of the box.

```ruby
class Receipt < ActiveRecord::Base
  serialize :price, Hash
end
```

Now passing the whole price breakdown into receipt is as simple as `receipt.price = product.price`.