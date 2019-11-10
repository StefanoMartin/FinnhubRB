require_relative '../spec_helper'

describe "1.0.0" do
  context "Forex" do
    it "create a new client" do
      @store[:client] = Finnhub::Client.new(key: @key, verbose: true)
      expect(@store[:client].class).to be Finnhub::Client
    end

    it "can retrieve multiple forex_exchanges" do
      forex_exchanges = @store[:client].forex_exchanges(plain: true)
      expect(forex_exchanges.class).to be Array

      @store[:forex_exchange_name] = forex_exchanges[0]

      forex_exchanges = @store[:client].forex_exchanges
      expect(forex_exchanges.class).to be Array
      expect(forex_exchanges[0].class).to be Finnhub::Forex_Exchange
    end

    it "can create a forex_exchange instance" do
      @store[:forex_exchange] = @store[:client].forex_exchange(name: @store[:forex_exchange_name])
      expect(@store[:forex_exchange].class).to be Finnhub::Forex_Exchange
    end

    it "can retrieve multiple symbols" do
      forex_symbols = @store[:forex_exchange].symbols(plain: true)
      expect(forex_symbols.class).to be Array

      @store[:forex_exchange_symbol] = forex_symbols[0][:symbol]

      forex_exchanges = @store[:forex_exchange].symbols
      expect(forex_exchanges.class).to be Array
      expect(forex_exchanges[0].class).to be Finnhub::Forex_Symbol
    end

    it "create a new forex_symbol" do
      @store[:forex_symbol] = @store[:forex_exchange].symbol(symbol: @store[:forex_exchange_symbol])
      expect(@store[:forex_symbol].class).to be Finnhub::Forex_Symbol
    end


    it "can retrieve timeseries" do
      timeseries = @store[:forex_symbol].timeseries(count: 100)
      expect(timeseries.open.class).to be Array
      expect(timeseries.high.class).to be Array
      expect(timeseries.low.class).to be Array
      expect(timeseries.close.class).to be Array
      expect(timeseries.volume.class).to be Array
      expect(timeseries.status).to eq "ok"
      expect(timeseries.output.class).to be Hash

      timeseries = @store[:forex_symbol].timeseries(resolution: 60, from: Time.now-24*30*3600, to: Time.now)
      expect(timeseries.open.class).to be Array
      expect(["ok", "no_data"]).to include timeseries.status

      timeseries = @store[:forex_symbol].timeseries(resolution: 60, from: Time.now-24*30*3600, to: Time.now, format: "csv")
      expect(timeseries.output.class).to be String

      error = nil
      begin
        @store[:forex_symbol].timeseries(resolution: 60, from: Time.now-24*30*3600, to: Time.now, format: "wrong")
      rescue Finnhub::Error => e
        error = e
      end
      expect(error.class).to be Finnhub::Error
    end
  end
end
