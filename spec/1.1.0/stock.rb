require_relative '../spec_helper'

describe "1.1.0" do
  context "Stock" do
    it "create a new client" do
      @store[:client] = Finnhub::Client.new(key: @key, verbose: true)
      expect(@store[:client].class).to be Finnhub::Client
    end
    
    it "retrieve stock exchanges" do
      @store[:stock] = @store[:client].stock_exchanges
      symbols = @store[:stock].map{|s| s.code}
      expect(symbols).to include "US"
    end

    it "retrieve symbols from stock exchanges" do
      symbols = @store[:stock][0].symbols
      expect(symbols[0].exchange).to eq @store[:stock][0].code
    end

    it "create a new stock" do
      @store[:stock] = @store[:client].stock(symbol: "AAPL")
      expect(@store[:stock].symbol).to eq "AAPL"
    end

    it "can retrieve a executive" do
      output = @store[:stock].executive

      expect(output[:symbol]).to eq "AAPL"
    end

    it "can retrieve a upgrade_downgrade" do
      output = @store[:stock].upgrade_downgrade

      expect(output[:symbol]).to eq "AAPL"
    end

    it "can retrieve metrics" do
      output = @store[:stock].metrics

      expect(output[:symbol]).to eq "AAPL"
    end

    it "can retrieve investors" do
      output = @store[:stock].investors

      expect(output[:symbol]).to eq "AAPL"
    end

    it "can retrieve funds" do
      output = @store[:stock].funds

      expect(output[:symbol]).to eq "AAPL"
    end

    it "can retrieve financials" do
      skip "Premium" if @skip_premium
      output = @store[:stock].financials

      expect(output[:symbol]).to eq "AAPL"
    end

    it "can retrieve quote" do
      skip "Premium"  if @skip_premium
      output = @store[:stock].quote

      expect(output[:symbol]).to eq "AAPL"
    end

    it "can retrieve major_development" do
      output = @store[:stock].major_development

      expect(output[:symbol]).to eq "AAPL"
    end

    it "can retrieve transcripts" do
      skip "Premium" if @skip_premium
      output = @store[:stock].transcripts

      expect(output[:symbol]).to eq "AAPL"
    end

    it "can retrieve tick" do
      skip "Premium" if @skip_premium
      output = @store[:stock].tick(from: Time.now-24*30*3600, to: Time.now)

      expect(output[:symbol]).to eq "AAPL"
    end
  end
end
