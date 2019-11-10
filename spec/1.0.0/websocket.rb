require_relative '../spec_helper'
require "thread"

describe "1.0.0" do
  context "Websocket" do
    before :all do
      @client = Finnhub::Client.new(key: @key, verbose: true)
      @result = nil
      @websocket = nil
      Thread.new do
        EM.run do
          @websocket = @client.websocket
          @websocket.on :message do |event|
            @result = event.data
          end
          @websocket.on :close do |event|
            @result = [:close, event.code, event.reason]
            @websocket = nil
          end
        end
      end
      sleep(0.5)
    end

    it "can subscribe" do
      @websocket.subscribe("AAPL")
      binding.pry
    end
  end
end
