module Finnhub
  module Calendar
    def economic_calendar
      request("/calendar/economic")
    end

    def earnings_calendar(from: nil, to: nil)
      url = "/calendar/earnings?"
      from = from.to_date.to_s if from.is_a?(Time)
      url += "&from=#{from}" unless from.nil?
      to = to.to_date.to_s if to.is_a?(Time)
      url += "&to=#{to}" unless to.nil?
      url[-1] = "" if url[-1] == "?"
      request(url)
    end

    def ipo_calendar
      request("/calendar/ipo")
    end

    def ico_calendar
      request("/calendar/ico")
    end
  end
end
