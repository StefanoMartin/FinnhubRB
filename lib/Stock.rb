module Finnhub
  class Stock
    include Finnhub::Analysis

    def initialize(client:, symbol:)
      @client = client
      @symbol = symbol
    end

    attr_reader :symbol

    def profile
      @client.request("/stock/profile?symbol=#{@symbol}")
    end

    def ceo_compensation
      @client.request("/stock/ceo-compensation?symbol=#{@symbol}")
    end

    def recommendation
      @client.request("/stock/recommendation?symbol=#{@symbol}")
    end

    def price_target
      @client.request("/stock/price-target?symbol=#{@symbol}")
    end

    def option_chain
      @client.request("/stock/option-chain?symbol=#{@symbol}")
    end

    def peers
      @client.request("/stock/peers?symbol=#{@symbol}")
    end

    def earnings
      @client.request("/stock/earnings?symbol=#{@symbol}")
    end

    def news
      @client.request("/news/#{@symbol}")
    end

    def sentiment
      @client.request("/news-sentiment?symbol=#{@symbol}")
    end

    def timeseries(**args)
      Finnhub::Timeseries.new(client: @client, stock: self, **args)
    end
  end
end
