require_relative '../spec_helper'
require "thread"

describe "1.0.0" do
  context "Websocket" do
    before :all do
      @client = Finnhub::Client.new(key: @key, verbose: true)
      @result = {result: nil}
      @websocket = nil
      Thread.new do
        EM.run do
          @websocket = @client.websocket
          @websocket.on :message do |event|
            puts event.data
            @result[:result] = event.data
          end
          @websocket.on :close do |event|
            puts [:close, event.code, event.reason]
            @result[:result] = [:close, event.code, event.reason]
            @websocket = nil
          end
        end
      end
      sleep(0.5)
    end

    it "can subscribe" do
      @websocket.subscribe("AAPL")
      error = true
      10.times do
        if @result[:result].nil?
          error = false
          break
        else
          sleep(0.5)
        end
      end
      expect(error).to be false
    end

    it "can unsubscribe" do
      @websocket.unsubscribe("AAPL")
      @result[:result] = nil
      sleep(0.5)
      expect(@result[:result].nil?).to be true
    end
  end
end
