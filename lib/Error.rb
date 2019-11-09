module Finnhub
  class Error < StandardError
    def initialize(message:, code: nil)
      @code = code
      super(message)
    end
    attr_reader :code
  end
end
