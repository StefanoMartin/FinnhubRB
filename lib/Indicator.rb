module Finnhub
  class Indicator
    def initialize(client:, stock:, resolution: "D", from:, to:, indicator:, args: {})
      url = "/indicator?symbol=#{stock.symbol}&resolution=#{resolution}"
      from = from.to_i if from.is_a?(Time)
      url += "&from=#{from}"
      to = to.to_i if to.is_a?(Time)
      url += "&to=#{to}"
      url += "&indicator=#{indicator}"
      args.each do |attribute, value|
        url += "&#{attribute}=#{value}"
      end
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

    def method_missing(name, *args, &block)
      operation(name.to_sym)
    end

    private

    def operation(type)
      raise Finnhub::Error message: "Output is not a hash" unless @output.is_a?(Hash)
      return [] if @output[type].nil?
      @timestamps.zip(@output[type])
    end
  end
end
