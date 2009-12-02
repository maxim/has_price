module HasPrice
  module CoreExtensions
    module Array
      # In case we're not in Rails.
      #
      # @see http://api.rubyonrails.org/classes/ActiveSupport/CoreExtensions/Array/ExtractOptions.html#M001202
      def extract_options!
        last.is_a?(::Hash) ? pop : {}
      end
    end
  end
end