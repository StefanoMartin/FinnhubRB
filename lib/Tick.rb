module Finnhub
  class Tick
    def initialize(client:, stock:, from:, to:)
      url = "/stock/candle?symbol=#{stock.symbol}"
      from = from.to_i if from.is_a?(Time)
      url += "&from=#{from}"
      to = to.to_i if to.is_a?(Time)
      @output = client.request(url)
      if @output.is_a?(Hash) && @output[:s] == "ok"
        @timestamps = @output[:trades][:t]&.map{|t| Time.strptime(t.to_s,'%L')}
      else
        @timestamps = []
      end
    end

    attr_reader :output, :timestamps

    def price
      operation(:p)
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
      return [] if @output[:trades][0][type].nil?
      @timestamps.zip(@output[:trades].map{|t| t[type]})
    end
  end
end
