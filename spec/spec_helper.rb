require "rspec"
require "pry-byebug"
require "yaml"
require "finnhub"

RSpec.configure do |config|
	config.color = true
	config.before(:all) do
		val = YAML.load_file("#{__dir__}/config.yml")
    @key = val["key"]
		@skip_premium = val["skip_premium"].nil? ? true : val["skip_premium"]
    @store = {}
	end
end
