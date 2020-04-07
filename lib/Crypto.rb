module Finnhub
  class Crypto_Exchange
    def initialize(client:, name:)
      @client = client
      @name = name
    end

    attr_reader :name

    def symbols(plain: false)
      output = @client.request("/crypto/symbol?exchange=#{@name}")
      return output if plain

      output.map do |o|
        Finnhub::Crypto_Symbol.new(client: @client, exchange: @name, **o)
      end
    end

    def symbol(**args)
      Finnhub::Crypto_Symbol.new(client: @client, exchange: @name, **args)
    end
  end

  class Crypto_Symbol
    include Finnhub::Analysis

    def initialize(client:, exchange:, description: nil, hasWM: nil,
      displaySymbol: nil, symbol: nil)
      @client = client
      @exchange = exchange
      @hashWM = hasWM
      @displaySymbol = displaySymbol
      @symbol = symbol
    end

    attr_reader :client, :exchange, :hashWM, :displaySymbol, :symbol

    def timeseries(**args)
      Finnhub::Crypto_Timeseries.new(client: @client, symbol: @symbol, **args)
    end
    alias :candles :timeseries
  end

  class Crypto_Timeseries < Finnhub::Timeseries
    def initialize(client:, symbol:, resolution: "D", count: nil,
      from: nil, to: nil, format: nil)
      url = "/crypto/candle?symbol=#{symbol}&resolution=#{resolution}"
      url += "&count=#{count}" unless count.nil?
      from = from.to_i if from.is_a?(Time)
      url += "&from=#{from}" unless from.nil?
      to = to.to_i if to.is_a?(Time)
      url += "&to=#{to}" unless to.nil?
      url += "&format=#{format}" unless format.nil?
      @output = client.request(url)
      if @output.is_a?(Hash) && @output[:s] == "ok"
        @timestamps = @output[:t]&.map{|t| DateTime.strptime(t.to_s,'%s')}
      else
        @timestamps = []
      end
    end
  end
end
