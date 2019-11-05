module Finnhub
  class Timeseries
    def initialize(client:, stock:, resolution: "D", count: nil,
      from: nil, to: nil, format: nil)
      url = "/stock/candle?symbol=#{stock.symbol}&resolution=#{resolution}"
      url += "&count=#{count}" unless count.nil?
      url += "&from=#{from}" unless from.nil?
      url += "&to=#{to}" unless to.nil?
      url += "&format=#{format}" unless format.nil?
      @output = client.request(url)
      @timestamps = @output[:t].map{|t| DateTime.strptime(t.to_s,'%s')}
    end

    attr_reader :output, :timestamps

    def open
      raise Finnhub::Error message: "Output is not a hash" unless @output.is_a?(Hash)
      @timestamps.zip(@output[:o])
    end

    def high
      raise Finnhub::Error message: "Output is not a hash" unless @output.is_a?(Hash)
      @timestamps.zip(@output[:h])
    end

    def low
      raise Finnhub::Error message: "Output is not a hash" unless @output.is_a?(Hash)
      @timestamps.zip(@output[:l])
    end

    def close
      raise Finnhub::Error message: "Output is not a hash" unless @output.is_a?(Hash)
      @timestamps.zip(@output[:c])
    end

    def volume
      raise Finnhub::Error message: "Output is not a hash" unless @output.is_a?(Hash)
      @timestamps.zip(@output[:v])
    end

    def status
      @output[:s]
    end
  end
end
