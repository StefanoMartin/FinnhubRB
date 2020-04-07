require_relative '../spec_helper'

describe "1.2.0" do
  context "Client" do
    it "can retrieve information about Covid-19" do
      @store[:client] = Finnhub::Client.new(key: @key, verbose: true)
      output = @store[:client].covid
      expect(output.size).to be >= 50
    end
  end

  context "Stock" do
    it "retrieve estimate" do
      @store[:stock] = @store[:client].stock(symbol: "AAPL")
      response = @store[:stock].revenue_estimate
      expect(response[:symbol]).to eq "AAPL"

      response = @store[:stock].earnings_estimate
      expect(response[:symbol]).to eq "AAPL"

      response = @store[:stock].earnings_calendar(from: Time.now-24*3600*365, to: Time.now)
      expect(response[:earningsCalendar].size).to be >= 1
    end

    it "retrieve dividends and splits" do
      response = @store[:stock].dividends(from: Time.now-24*3600*365, to: Time.now)
      expect(response.size).to be >= 1

      response = @store[:stock].splits(from: Time.now-10*24*3600*365, to: Time.now)
      expect(response.size).to be >= 1
    end

    it "can use indicators" do
      indicator = @store[:stock].indicator(from: Time.now-24*30*3600, to: Time.now, resolution: 60, indicator: "sma", args: {timeperiod: 3})
      expect(indicator.sma.size).to be >= 1
      expect(indicator.o).to eq indicator.open
      expect(indicator.ciao).to eq []
    end
  end
end
