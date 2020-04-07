module Finnhub
  class Webhook
    def initialize(client:, id: nil, hash: nil)
      @client = client
      @id = id
      @hash = hash
    end

    attr_reader :id, :hash

    def create(body:)
      response = @client.request("/webhook/add", method: :post, body: body)
      @id = response[:id]
      response
    end

    def delete
      response = @client.request("/webhook/delete", method: :post, body: {id: @id})
      @id = nil
      response
    end
  end
end
