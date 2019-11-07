module Finnhub
  class Websocket < Faye::WebSocket::Client
    def initialize(apikey)
      super("wss://ws.finnhub.io?token=#{apikey}")
    end

    def subscribe(symbol)
      case symbol
      when Finnhub::Stock, Finnhub::Crypto_Symbol, Finnhub::Forex_Symbol
        symbol = symbol.symbol
      end

      send(Oj.dump({"type": "subscribe", "symbol": symbol}))
    end

    def unsubscribe(symbol)
      case symbol
      when Finnhub::Stock, Finnhub::Crypto_Symbol, Finnhub::Forex_Symbol
        symbol = symbol.symbol
      end

      send(Oj.dump({"type": "unsubscribe", "symbol": symbol}))
    end
  end
end
