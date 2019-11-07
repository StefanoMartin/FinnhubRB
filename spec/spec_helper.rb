require "rspec"
require "pry-byebug"
require "yaml"
require_relative "../lib/finnhub"

RSpec.configure do |config|
	config.color = true
	config.before(:all) do
		val = YAML.load_file("#{__dir__}/config.yml")
    @key = val["key"]
    @store = {}
	end
end
