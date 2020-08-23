module Adapters
  class AlphaVantage
    def initialize
      @client = Alphavantage::Client.new key: ENV["ALPHAVANTAGE_API_KEY"]
    end
    # TODO
  end
end
