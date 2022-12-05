# frozen_string_literal: true

module Orderspace
  class Endpoint
    attr_reader :client

    def initialize(client)
      @client = client
    end
  end
end
