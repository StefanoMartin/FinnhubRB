module Finnhub
  class Forex_Exchange
    def initialize(client:, name:)
      @client = client
      @name = name
    end

    attr_reader :name

    def symbols(plain: false)
      output = @client.request("/forex/symbol?exchange=#{@name}")
      return output if plain

      output.map do |o|
        Finnhub::Forex_Symbol.new(client: @client, exchange: @name, **o)
      end
    end

    def symbol(**args)
      Finnhub::Forex_Symbol.new(client: @client, exchange: @name, **args)
    end
  end

  class Forex_Symbol
    include Finnhub::Analysis

    def initialize(client:, exchange: nil, description: nil, hasWM: nil,
      displaySymbol: nil, symbol:)
      @client = client
      @exchange = exchange
      @hashWM = hasWM
      @displaySymbol = displaySymbol
      @symbol = symbol
    end

    attr_reader :client, :exchange, :hashWM, :displaySymbol, :symbol

    def timeseries(**args)
      Finnhub::Forex_Timeseries.new(client: @client, symbol: @symbol, **args)
    end
    alias :candles :timeseries
  end

  class Forex_Timeseries < Finnhub::Timeseries
    def initialize(client:, symbol:, resolution: "D", count: nil,
      from: nil, to: nil, format: nil)
      url = "/forex/candle?symbol=#{symbol}&resolution=#{resolution}"
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
