module Finnhub
  class Economic_Code
    def initialize(client:, code:, description:)
      @client = client
      @code = code
      @description = description
    end

    attr_reader :code, :description

    def data(plain: false)
      output = @client.request("/economic?code=#{@code}")
      return output if plain

      output.map{|o| [Time.parse(o[0]), o[1]]}
    end
  end
end
