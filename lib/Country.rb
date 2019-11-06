module Finnhub
  class Merge_Country
    def initialize(client:, country:)
      @client = client
      @country = country
    end

    attr_reader :country

    def merger(from: nil, to: nil)
      url = "/merger?country=#{@client}"
      url += "&from=#{from}" unless from.nil?
      url += "&to=#{to}" unless to.nil?
      @client.request(url)
    end
  end
end
