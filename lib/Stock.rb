module Finnhub
  class Stock_Exchange
    def initialize(client:, code:, hash:)
      @client = client
      @hash = hash
      @code = code
    end

    attr_reader :hash, :code

    def symbols(plain: false)
      output = @client.request("/stock/symbol?exchange=#{@code}")
      return output if plain

      output.map do |o|
        Finnhub::Stock.new(client: @client, exchange: @code, **o)
      end
    end

    def symbol(**args)
      Finnhub::Stock.new(client: @client, exchange: @code, **args)
    end
  end


  class Stock
    include Finnhub::Analysis

    def initialize(client:, symbol:,
      displaySymbol: nil, description: nil, exchange: nil)
      @client = client
      @symbol = symbol
      @displaySymbol = displaySymbol
      @description = description
      @exchange = exchange
    end

    attr_reader :symbol, :displaySymbol, :description, :exchange

    def profile(isin: nil, cusip: nil)
      if !isin.nil?
        string = "isin".freeze
        symbol = isin
      elsif !cusip.nil?
        string = "cusip".freeze
        symbol = cusip
      else
        string = "symbol".freeze
        symbol = @symbol
      end
      @client.request("/stock/profile?#{string}=#{symbol}")
    end

    def ceo_compensation
      @client.request("/stock/ceo-compensation?symbol=#{@symbol}")
    end

    def executive
      @client.request("/stock/executive?symbol=#{@symbol}")
    end

    def recommendation
      @client.request("/stock/recommendation?symbol=#{@symbol}")
    end

    def price_target
      @client.request("/stock/price-target?symbol=#{@symbol}")
    end

    def upgrade_downgrade
      @client.request("/stock/upgrade-downgrade?symbol=#{@symbol}")
    end

    def option_chain
      @client.request("/stock/option-chain?symbol=#{@symbol}")
    end

    def peers(plain: false)
      output = @client.request("/stock/peers?symbol=#{@symbol}")
      return output if plain

      output.map{|o| Finnhub::Stock.new(client: @client, symbol: o)}
    end

    def earnings(limit: nil)
      url = "/stock/earnings?symbol=#{@symbol}"
      url += "&limit=#{limit}" unless limit.nil?
      @client.request(url)
    end

    def metrics(metric: "price")
      @client.request("/stock/metric?symbol=#{@symbol}&metric=#{metric}")
    end

    def investors(limit: nil)
      url = "/stock/investor-ownership?symbol=#{@symbol}"
      url += "&limit=#{limit}" unless limit.nil?
      @client.request(url)
    end

    def funds(limit: nil)
      url = "/stock/fund-ownership?symbol=#{@symbol}"
      url += "&limit=#{limit}" unless limit.nil?
      @client.request(url)
    end

    def financials(statement: "bs", freq: "annual")
      @client.request("/stock/financials?symbol=#{@symbol}&statement=#{statement}&freq=#{freq}")
    end

    def quote
      @client.request("/quote?symbol=#{@symbol}")
    end

    def news
      @client.request("/news/#{@symbol}")
    end

    def major_development
      @client.request("/major-development?symbol=#{@symbol}")
    end

    def sentiment
      @client.request("/news-sentiment?symbol=#{@symbol}")
    end

    def transcripts(plain: false)
      output = @client.request("/stock/transcripts/list?symbol=#{@symbol}")
      return output if plain

      output[:transcripts].map{|o| Finnhub::Transcript.new(client: self, id: o[:id], hash: o)}
    end

    def timeseries(**args)
      Finnhub::Timeseries.new(client: @client, stock: self, **args)
    end
    alias :candles :timeseries

    def tick(**args)
      Finnhub::Tick.new(client: @client, stock: self, **args)
    end
  end
end
