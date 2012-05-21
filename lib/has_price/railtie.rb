module HasPrice
  class Railtie < Rails::Railtie
    initializer "has_price.configure_rails_initialization" do
      ActiveRecord::Base.extend HasPrice
    end
  end
end
