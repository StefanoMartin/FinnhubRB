module Finnhub
  class Client
    include Calendar

    BASE_URI = 'https://finnhub.io/api/v1'

    def initialize(key:, verbose: false)
      @apikey = key
      @verbose = verbose
    end

    attr_accessor :verbose
    attr_reader :apikey

    def request(url)
      send_url = "#{BASE_URI}#{url}"
      send_url += send_url.include?("?") ? "&" : "?"
      send_url += "token=#{@apikey}"

      puts "\nGET #{send_url}\n" if @verbose
      response = HTTParty.get(send_url)
      if @verbose
        puts "\nCODE: #{response.code}\n"
        puts "OUTPUT: #{response.body}\n"
      end

      if response.code == 200
        data = response.body
        return data unless data[0] == "[" || data[0] == "{"

        data = Oj.load(data, symbol_keys: true)
        return data
      else
        raise Finnhub::Error.new message: data, code: response.code
      end

    rescue Finnhub::Error => e
      raise e
    rescue StandardError => e
      raise Finnhub::Error.new message: "Failed request: #{e.message}"
    end

    def websocket
      Finnhub::Websocket.new(@apikey)
    end

    def stock(symbol:)
      Finnhub::Stock.new(client: self, symbol: symbol)
    end

    def forex_exchanges(plain: false)
      output = request("/forex/exchange")
      return output if plain

      output.map{|o| Finnhub::Forex_Exchange.new(client: self, name: o)}
    end

    def forex_exchange(name:)
      Finnhub::Forex_Exchange.new(client: self, name: name)
    end

    def crypto_exchanges(plain: false)
      output = request("/crypto/exchange")
      return output if plain

      output.map{|o| Finnhub::Crypto_Exchange.new(client: self, name: o)}
    end

    def crypto_exchange(name:)
      Finnhub::Crypto_Exchange.new(client: self, name: name)
    end

    def news(category: "general", minId: nil)
      url = "/news?category=#{category}"
      url += "&minId=#{minId}" unless minId.nil?
      request(url)
    end

    def merge_countries(plain: false)
      output = request("/merger/country")
      return output if plain

      output.map{|o| Finnhub::Merge_Country.new(client: self, country: o)}
    end

    def merge_country(country:)
      Finnhub::Merge_Country.new(client: self, country: country)
    end

    def economic_codes(plain: false)
      output = request("/economic/code")
      return output if plain

      output.map{|o| Finnhub::Economic_Code.new(client: self, code: o[0], description: o[1])}
    end

    def economic_code(code:, description: nil)
      Finnhub::Economic_Code.new(client: self, code: code,
        description: description)
    end
  end
end
