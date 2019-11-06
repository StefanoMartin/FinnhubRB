module Finnhub
  module Calendar
    def economic_calendar
      request("/calendar/economic")
    end

    def earnings_calendar
      request("/calendar/earnings")
    end

    def ipo_calendar
      request("/calendar/ipo")
    end

    def ico_calendar
      request("/calendar/ico")
    end
  end
end
