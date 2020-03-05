module Finnhub
  class Timeseries
    def initialize(client:, stock:, resolution: "D", count: 100,
      from: nil, to: nil, format: nil, adjusted: false)
      url = "/stock/candle?symbol=#{stock.symbol}&resolution=#{resolution}"
      url += "&count=#{count}" unless count.nil?
      from = from.to_i if from.is_a?(Time)
      url += "&from=#{from}" unless from.nil?
      to = to.to_i if to.is_a?(Time)
      url += "&to=#{to}" unless to.nil?
      url += "&format=#{format}" unless format.nil?
      url += "&adjusted=#{adjusted}" if adjusted
      @output = client.request(url)
      if @output.is_a?(Hash) && @output[:s] == "ok"
        @timestamps = @output[:t]&.map{|t| Time.strptime(t.to_s,'%s')}
      else
        @timestamps = []
      end
    end

    attr_reader :output, :timestamps

    def open
      operation(:o)
    end

    def high
      operation(:h)
    end

    def low
      operation(:l)
    end

    def close
      operation(:c)
    end

    def volume
      operation(:v)
    end

    def status
      raise Finnhub::Error message: "Output is not a hash" unless @output.is_a?(Hash)
      @output[:s]
    end

    private

    def operation(type)
      raise Finnhub::Error message: "Output is not a hash" unless @output.is_a?(Hash)
      return [] if @output[type].nil?
      @timestamps.zip(@output[type])
    end
  end
end
