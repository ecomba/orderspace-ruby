# frozen_string_literal: true

module Orderspace
  ##
  # Defines the parent class for the endpoints
  class Endpoint
    attr_reader :client

    ##
    # Endpoints are initialized by passing the client
    # @param client [Orderspace::Client] the Orderspace client that interacts with the Orderspace API
    def initialize(client)
      @client = client
    end
  end
end
