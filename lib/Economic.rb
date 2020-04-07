module Finnhub
  class Economic_Code
    def initialize(client:, code:, hash:)
      @client = client
      @code = code
      @hash = hash
    end

    attr_reader :code, :hash

    def data(plain: false)
      output = @client.request("/economic?code=#{@code}")
      return output if plain

      output.map{|o| [Time.parse(o[0]), o[1]]}
    end
  end
end
