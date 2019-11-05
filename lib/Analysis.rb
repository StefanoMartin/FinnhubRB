module Finnhub
  module Analysis
    def pattern(resolution: "D")
      request("/scan/pattern?symbol=#{@symbol}&resolution=#{resolution}")
    end

    def support_resistance(resolution: "D")
      request("/scan/support-resistance?symbol=#{@symbol}&resolution=#{resolution}")
    end

    def techinical_indicators(resolution: "D")
      request("/scan/technical-indicator?symbol=#{@symbol}&resolution=#{resolution}")
    end
  end
end
