require_relative '../spec_helper'

describe "1.0.0" do
  context "Finnhub" do
    it "create a new client" do
      @store[:client] = Finnhub::Client.new(key: @key)
      expect(@store[:client].class).to be Finnhub::Client
    end

    it "create a new stock" do
      @store[:stock] = @store[:client].stock(symbol: "AAPL")
      expect(@store[:stock].symbol).to eq "AAPL"
    end

    it "can retrieve a profile" do
      output = @store[:stock].profile

      expect(output[:ticker]).to eq "AAPL"
    end

    it "can retrieve a ceo_compensation" do
      output = @store[:stock].ceo_compensation

      expect(output[:companyName]).to eq "Apple Inc."
    end

    it "can retrieve a recommendation" do
      output = @store[:stock].recommendation

      expect(output[0][:symbol]).to eq "AAPL"
    end

    it "can retrieve a price_target" do
      output = @store[:stock].price_target

      expect(output[:symbol]).to eq "AAPL"
    end

    it "can retrieve a option_chain" do
      output = @store[:stock].option_chain

      expect(output[:code]).to eq "AAPL"
    end

    it "can retrieve a peers" do
      output = @store[:stock].peers(plain: true)
      expect(output).to include "ALOT"

      output2 = @store[:stock].peers[0].profile
      expect(output2[:ticker]).to eq output[0]
    end

    it "can retrieve a earnings" do
      output = @store[:stock].earnings

      expect(output[0][:symbol]).to eq "AAPL"
    end

    it "can retrieve a news" do
      output = @store[:stock].news

      expect(output[0][:related]).to eq "AAPL"
    end

    it "can retrieve a sentiment" do
      output = @store[:stock].sentiment

      expect(output[:symbol]).to eq "AAPL"
    end

    it "can retrieve timeseries" do
      timeseries = @store[:stock].timeseries(count: 100)
      expect(timeseries.open.class).to be Array
      expect(timeseries.high.class).to be Array
      expect(timeseries.low.class).to be Array
      expect(timeseries.close.class).to be Array
      expect(timeseries.volume.class).to be Array
      expect(timeseries.status).to be "ok"
      expect(timeseries.output.class).to be Hash

      timeseries = @store[:stock].timeseries(resolution: 60, from: Time.now-24*30*3600, to: Time.now)
      expect(timeseries.open.class).to be Array
      expect(timeseries.status).to be "ok"
    end
  end
end
