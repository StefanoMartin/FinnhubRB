require_relative '../spec_helper'

describe "1.0.0" do
  context "Other" do
    it "create a new client" do
      @store[:client] = Finnhub::Client.new(key: @key, verbose: true)
      expect(@store[:client].class).to be Finnhub::Client
    end

    it "can retrieve news" do
      output = @store[:client].news(category: "forex")
      expect(output[0][:datetime].class).to be Integer
    end

    it "can retrieve merge countries" do
      output = @store[:client].merge_countries(plain: true)
      expect(output).to include "France"
      @store[:country] = output[0]

      output = @store[:client].merge_countries
      expect(output[0].class).to be Finnhub::Merge_Country
    end

    it "can retrieve merge countries" do
      skip "Premium" if @skip_premium
      country = @store[:client].merge_country(country: @store[:country])
      mergers = country.merger
      expect(mergers[0][:targetNation]).to eq @store[:country]
    end

    it "can retrieve economic codes" do
      output = @store[:client].economic_codes(plain: true)
      expect(output.size).to be > 100
      @store[:economic_code] = output[0][:code]

      output = @store[:client].economic_codes
      expect(output[0].class).to be Finnhub::Economic_Code
    end

    it "can retrieve economic codes" do
      economic = @store[:client].economic_code(code: @store[:economic_code])
      output = economic.data(plain: true)
      expect(output[0][0].class).to eq String

      output = economic.data
      expect(output[0][0].class).to eq Time
    end

    it "can retrieve calendars" do
      calendar = @store[:client].economic_calendar
      expect(calendar.key?(:economicCalendar)).to eq true

      calendar = @store[:client].earnings_calendar
      expect(calendar.key?(:earningsCalendar)).to eq true

      calendar = @store[:client].ipo_calendar
      expect(calendar.key?(:ipoCalendar)).to eq true

      calendar = @store[:client].ico_calendar
      expect(calendar.key?(:icoCalendar)).to eq true
    end
  end
end
