# lib = File.expand_path("../lib", __FILE__)
# $LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

Gem::Specification.new do |s|
  s.name        = "finnhubrb"
  s.version	    = "1.2.0"
  s.authors     = ["Stefano Martin"]
  s.email       = ["stefano.martin87@gmail.com"]
  s.homepage    = "https://github.com/StefanoMartin/FinnhubRB"
  s.license     = "MIT"
  s.summary     = "A gem for Alpha Vantage"
  s.description = "A ruby wrapper for Finnhub's HTTP API"
  s.platform	   = Gem::Platform::RUBY
  s.require_paths = ["lib"]
  s.files         = Dir["lib/*"] + Dir["spec/**/*"] + ["FinnhubRB.gemspec", "Gemfile", "LICENSE.md", "README.md"]
  s.add_runtime_dependency "httparty", ">= 0.17.0"
  s.add_runtime_dependency "oj",">= 3.9.0"
  s.add_runtime_dependency "faye-websocket", ">= 0.10.9"
  s.add_development_dependency "pry-byebug"
  s.add_development_dependency "rspec", ">=3.5"
  s.add_development_dependency "awesome_print",  ">= 1.7"
  s.add_development_dependency "eventmachine", ">= 1.2.7"
end
