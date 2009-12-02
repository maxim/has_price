module HasPrice
  module CoreExtensions
    module String
      # In case we're not in Rails.
      #
      # @see http://api.rubyonrails.org/classes/Inflector.html#M001631
      def underscore
        gsub(/::/, '/').
        gsub(/([A-Z]+)([A-Z][a-z])/,'\1_\2').
        gsub(/([a-z\d])([A-Z])/,'\1_\2').
        tr("-", "_").
        downcase
      end
    end
  end
end