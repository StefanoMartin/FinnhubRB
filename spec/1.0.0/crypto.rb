require_relative '../spec_helper'

describe "1.0.0" do
  context "Crypto" do
    it "create a new client" do
      @store[:client] = Finnhub::Client.new(key: @key, verbose: true)
      expect(@store[:client].class).to be Finnhub::Client
    end

    it "can retrieve multiple crypto_exchanges" do
      crypto_exchanges = @store[:client].crypto_exchanges(plain: true)
      expect(crypto_exchanges.class).to be Array

      @store[:crypto_exchange_name] = crypto_exchanges[0]

      crypto_exchanges = @store[:client].crypto_exchanges
      expect(crypto_exchanges.class).to be Array
      expect(crypto_exchanges[0].class).to be Finnhub::Crypto_Exchange
    end

    it "can create a crypto_exchange instance" do
      @store[:crypto_exchange] = @store[:client].crypto_exchange(name: @store[:crypto_exchange_name])
      expect(@store[:crypto_exchange].class).to be Finnhub::Crypto_Exchange
    end

    it "can retrieve multiple symbols" do
      crypto_symbols = @store[:crypto_exchange].symbols(plain: true)
      expect(crypto_symbols.class).to be Array

      @store[:crypto_exchange_symbol] = crypto_symbols[0][:symbol]

      crypto_symbols = @store[:crypto_exchange].symbols
      expect(crypto_symbols.class).to be Array
      expect(crypto_symbols[0].class).to be Finnhub::Crypto_Symbol
    end

    it "create a new crypto_symbol" do
      @store[:crypto_symbol] = @store[:crypto_exchange].symbol(symbol: @store[:crypto_exchange_symbol])
      expect(@store[:crypto_symbol].class).to be Finnhub::Crypto_Symbol
    end


    it "can retrieve timeseries" do
      timeseries = @store[:crypto_symbol].timeseries(count: 100)
      expect(timeseries.open.class).to be Array
      expect(timeseries.high.class).to be Array
      expect(timeseries.low.class).to be Array
      expect(timeseries.close.class).to be Array
      expect(timeseries.volume.class).to be Array
      expect(timeseries.status).to eq "ok"
      expect(timeseries.output.class).to be Hash

      timeseries = @store[:crypto_symbol].timeseries(resolution: 60, from: Time.now-24*30*3600, to: Time.now)
      expect(timeseries.open.class).to be Array
      expect(timeseries.status).to eq "ok"

      timeseries = @store[:crypto_symbol].timeseries(resolution: 60, from: Time.now-24*30*3600, to: Time.now, format: "csv")
      expect(timeseries.output.class).to be String

      error = nil
      begin
        @store[:crypto_symbol].timeseries(resolution: 60, from: Time.now-24*30*3600, to: Time.now, format: "wrong")
      rescue Finnhub::Error => e
        error = e
      end
      expect(error.class).to be Finnhub::Error
    end

    it "can retrieve pattern" do
      output = @store[:crypto_symbol].pattern
      expect(output[:points][0].key?(:symbol)).to eq true
    end

    it "can retrieve support_resistance" do
      output = @store[:crypto_symbol].support_resistance
      expect(output.key?(:levels)).to be true
    end

    it "can retrieve techinical_indicators" do
      output = @store[:crypto_symbol].techinical_indicators
      expect(output.key?(:technicalAnalysis)).to be true
    end
  end
end
