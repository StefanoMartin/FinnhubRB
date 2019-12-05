FinnhubRB [![Gem Version](https://badge.fury.io/rb/finnhubrb.svg)](https://badge.fury.io/rb/finnhubrb)
=========================================================

[Finnhub](https://finnhub.io/) is an API for retrieving Stock
market data in JSON or CSV format.
FinnhubRB is a wrapper Gem to use Finnhub with Ruby. FinnhubRB is based
on the [HTTP API of Finnhub](https://finnhub.io/docs/api).

To install FinnhubRB: `gem install finnhubrb`

To use it in your application: `require "finnhubrb"`

## How to test

To test the Gem create a config.yml file inside the folder /spec with inside a line

``` ruby
key: [YOUR KEY]
```

Then run "rspec spec/test_all.rb".

## Support

* Without a premium account, testing is hard and I could have missed something. Any bug, suggestions and improvements are more than welcome. Please do not be shy to create issues or pull requests.
* This is a personal project, any stars for giving your support will make a man happy.

## Client

To contact Alpha Vantage you need to use a valid key that you can require from [here](https://finnhub.io/register).

To setup your clients use:

``` ruby
client = Finnhub::Client.new(key: "YOURKEY")
```

If you want to see the request that the client will do to Finnhub you can
setup verbose equal to true.

``` ruby
  client.verbose = true # You can setup this during the initialization too
```

## Stock

Finnhub::Stock is used to manage a stock class.
To create a new Stock class you can use a client.

``` ruby
stock = client.stock symbol: "AAPL"
```

Several methods are available under this class:

``` ruby
  stock.symbol # Return the symbol
  stock.profile # Retrieve profile of the stock
  stock.ceo_compensation # Retrieve compensation of the stock's CEO
  stock.recommendation # Retrieve recommendation about this stock
  stock.price_target # Retrieve price target about this stock
  stock.option_chain # Retrieve option chain about this stock
  stock.earnings # Retrieve earnings about this stock
  stock.news # Retrieve news about this stock (only US)
  stock.sentiment # Retrieve social sentiment about this stock (only US)
  stock.peers(plain: true) # Retrieve peers company similar to the one chosen
  stock.peers # Like the previous one, but the results are Finnhub::Stock instances
  stock.pattern # Retrieve pattern
  stock.support_resistance # Retrieve support resistance
  stock.technical_indicators # Retrieve techinical indicators
```

To create a timeseries you can use:

``` ruby
  stock.timeseries(count: 100) # Return the last 100 entries (default count is 100)
  stock.timeseries(resolution: "D") # Resolution is daily "D", alternative are 1, 5, 15, 30, 60, D, W, M) where the numeric one are for minutes (default resolution is "D")
  stock.timeseries(from: Time.now-24*30*3600, to: Time.now) # Fetch from a date to another date (default from: nil, to: nil)
  stock.timeseries(format: "json") # Return the output in json or in csv (default format: "json")
```

Remember count and from/to are exclusive. If you use one, you cannot use the other two.
The methods "open", "high", "low", "close", "volume" and "status" will not work if you use format csv.

``` ruby
  timeseries = stock.timeseries(from: Time.now-24*30*3600, to: Time.now, resolution: 60)
  timeseries.output # Return output obtained from the request
  timeseris.timestamps # Return timestamps obtained from the request
  timeseries.open # Return open obtained from the request  
  timeseries.low # Return low obtained from the request
  timeseries.close # Return close obtained from the request
  timeseries.volume # Return volume obtained from the request
  timeseries.status # Return status obtained from the request  
```

## Crypto

To analyse a crypto currency you should start by choosing which crypto exchange you want to analyse.

``` ruby
client.crypto_exchanges # Retrieve the available crypto exchanges on Finnhub (Finnhub::Crypto_Exchange instances)
client.crypto_exchanges(plain: true) # As above, but it returns simply the output of the request
crypto_exchange = client.crypto_exchange(name: "NAME_CRYPTO_EXCHANGE") # Create a single instance of Finnhub::Crypto_Exchange
```

After that you can choose, in that crypto exchange which symbol you want to check.

``` ruby
crypto_exchange.symbols # Retrieve the available crypto symbols on the chosen crypto exchange (Finnhub::Crypto_Symbol instances)
crypto_exchange.symbols(plain: true) # As above, but it returns simply the output of the request
crypto_symbol = crypto_exchange.symbol(symbol: "BTC") # Create a single instance of Finnhub::Crypto_Symbol
```

From crypto_symbol instance you can retrieve some interesting information.

``` ruby
crypto_symbol.exchange # Exchange of the crypto_symbol
crypto_symbol.hasWM # If it has week and month
crypto_symbol.displaySymbol # Displayed symbol
crypto_symbol.symbol # Symbol of the crypto currency
```

Furthermore you can create a timeseries with the same logic used for Stock timeseries.

``` ruby
  timeseries = crypto_symbol.timeseries(from: Time.now-24*30*3600, to: Time.now, resolution: 60)
  timeseries.output # Return output obtained from the request
  timeseris.timestamps # Return timestamps obtained from the request
  timeseries.open # Return open obtained from the request  
  timeseries.low # Return low obtained from the request
  timeseries.close # Return close obtained from the request
  timeseries.volume # Return volume obtained from the request
  timeseries.status # Return status obtained from the request  
```

## Forex

To analyse a forex exchange you should start by choosing which forex exchange you want to analyse.

``` ruby
client.forex_exchanges # Retrieve the available forex exchanges on Finnhub (Finnhub::Forex_Exchange instances)
client.forex_exchanges(plain: true) # As above, but it returns simply the output of the request
forex_exchange = client.forex_exchange(name: "NAME_FOREX_EXCHANGE") # Create a single instance of Finnhub::Forex_Exchange
```

After that you can choose, in that forex exchange which symbol you want to check.

``` ruby
forex_exchange.symbols # Retrieve the available forex symbols on the chosen forex exchange (Finnhub::Forex_Symbol instances)
forex_exchange.symbols(plain: true) # As above, but it returns simply the output of the request
forex_symbol = forex_exchange.symbol(symbol: "USD") # Create a single instance of Finnhub::Forex_Symbol
```

From forex_symbol instance you can retrieve some interesting information.

``` ruby
forex_symbol.exchange # Exchange of the crypto_symbol
forex_symbol.hasWM # If it has week and month
forex_symbol.displaySymbol # Displayed symbol
forex_symbol.symbol # Symbol of the crypto currency
```

Furthermore you can create a timeseries with the same logic used for Stock timeseries.

``` ruby
  timeseries = forex_symbol.timeseries(from: Time.now-24*30*3600, to: Time.now, resolution: 60)
  timeseries.output # Return output obtained from the request
  timeseris.timestamps # Return timestamps obtained from the request
  timeseries.open # Return open obtained from the request  
  timeseries.low # Return low obtained from the request
  timeseries.close # Return close obtained from the request
  timeseries.volume # Return volume obtained from the request
  timeseries.status # Return status obtained from the request  
```

## Merge

You can retrieve information about company that are merging in relation of a given country.

``` ruby
client.merge_countries # Retrieve the available merge countries on Finnhub (Finnhub::Merge_Country instances)
client.merge_countries(plain: true) # As above, but it returns simply the output of the request
country = client.merge_country(country: "France") # Create a single instance of Finnhub::Merge_Country
country.merger # Fetch information about the company that are going to merge
```

## Economic Code

You can retrieve information about economic_codes.

``` ruby
client.economic_codes # Retrieve the available economic_codes on Finnhub (Finnhub::Economic_Code instances)
client.economic_codes(plain: true) # As above, but it returns simply the output of the request
economic = client.economic_code(code: "CODE") # Create a single instance of Finnhub::Economic_Code
economic.data # Data of economic_code
economic.data(plaint: true) # As above, but it returns simply the output of the request
```

## News and calendar

You can retrieve news and calendar in the following way.

``` ruby
client.news(category: "forex") # Retrieve news by category (general, forex, crypto, merger) and by minId (default 0)
client.economic_calendar # Retrieve economic calendar
client.earnings_calendar # Retrieve earning calendar
client.ipo_calendar # Retrieve IPO calendar
client.ico_calendar # Retrieve ICO calendar
```

## Websocket

Here an example of how to create websocket.

``` ruby
Thread.new do
  EM.run do
    websocket = client.websocket # Create websocket
    websocket.on :message do |event|
      result = event.data # Result is not parsed
    end
    websocket.on :close do |event|
      result = [:close, event.code, event.reason]
      websocket = nil
    end  
  end
end

websocket.subscribe("AAPL") # Subscribe to a stock
websocket.unsubscribe("AAPL") # Unubscribe to a stock
```

The symbol under subscribe/unsubscribe can be a string of a stock, a crypto_symbol or a forex_symbol. Or in alternative can be a Finnhub::Stock, Finnhub::Crypto_Symbol, or a Finnhub::Forex_Symbol instance.

## Errors

Error from FinnhubRB are returned under Finnhub::Error exception. You can use e.code to retrieve the code returned to a not successful request.
