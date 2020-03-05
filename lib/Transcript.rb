module Finnhub
  class Transcript
    def initialize(client:, id:, hash: nil)
      @client = client
      @id = id
      @hash = hash
    end

    attr_reader :id, :hash

    def transcript
      @client.request("/stock/transcripts?id=#{@id}")
    end
  end
end
