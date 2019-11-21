module Finnhub
  module Analysis
    def pattern(resolution: "D")
      @client.request("/scan/pattern?symbol=#{@symbol}&resolution=#{resolution}")
    end

    def support_resistance(resolution: "D")
      @client.request("/scan/support-resistance?symbol=#{@symbol}&resolution=#{resolution}")
    end

    def technical_indicators(resolution: "D")
      @client.request("/scan/technical-indicator?symbol=#{@symbol}&resolution=#{resolution}")
    end
  end
end
