module Finnhub
  class Merge_Country
    def initialize(client:, country:)
      @client = client
      @country = country
    end

    attr_reader :country

    def merger(from: nil, to: nil)
      url = "/merger?country=#{@country}"
      from = from.to_date.to_s if from.is_a?(Time)
      url += "&from=#{from}"
      to = to.to_date.to_s if to.is_a?(Time)
      url += "&to=#{to}"
      @client.request(url)
    end
  end
end
