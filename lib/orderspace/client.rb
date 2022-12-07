# frozen_string_literal: true

require 'httparty'

module Orderspace
  ##
  # This class is the entrypoint to the Orderspace API
  #
  # To obtain an access token you will have to have registered a private application
  # with Orderspace (https://<your_space>.orderspace.com/admin/apps/new).
  # This will give you the client_id and client_secret you need in order to get your access token.
  #
  # client = Client.with(client_key, client_secret)
  class Client

    include Default

    HEADER_AUTHORIZATION = 'Authorization'
    API_VERSION = 'v1'

    attr_reader :access_token

    def initialize(access_token = nil)
      @access_token = access_token
    end

    def self.with(client_id, client_secret)
      credentials = new.oauth.obtain_access_token(client_id, client_secret)
      new(credentials.access_token)
    end

    ##
    # Represents the base url to Orderspace's API (i.e. https://api.orderspace.com/)
    # @return [String] the base url to Orderspace's API
    def self.base_url
      BASE_URL
    end

    ##
    # Represents the URL to the Orderspace API with it's version (i.e. https://api.orderspace.com/v1/)
    # @return [String] the versioned Orderspace API url
    def self.versioned_url
      "#{base_url}#{API_VERSION}/"
    end

    ##
    # Returns the oauth endpoint
    def oauth
      OauthEndpoint.new(self)
    end

    ##
    # Returns the customers endpoint
    def customers
      CustomersEndpoint.new(self)
    end

    ##
    # Returns the orders endpoint
    def orders
      OrdersEndpoint.new(self)
    end

    ##
    # Returns the webhooks endpoint
    def webhooks
      WebhooksEndpoint.new(self)
    end

    class OauthEndpoint < Orderspace::Endpoint
      include Orderspace::Endpoint::Oauth
    end

    class CustomersEndpoint < Orderspace::Endpoint
      include Orderspace::Endpoint::Customers
    end

    class OrdersEndpoint < Orderspace::Endpoint
      include Orderspace::Endpoint::Orders
    end

    class WebhooksEndpoint < Orderspace::Endpoint
      include Orderspace::Endpoint::Webhooks
    end

    def get(path, options = {})
      execute(:get, path, nil, options.to_h)
    end

    def post(path, data = nil, options = {})
      execute(:post, path, data, options)
    end

    def put(path, data = nil, options = {})
      execute(:put, path, data, options)
    end

    def delete(path, data = nil, options = {})
      execute(:delete, path, data, options)
    end

    def execute(method, path, data = nil, options = {})
      uri = Client.versioned_url + path
      response = request(method, uri, data, options)

      case response.code
      when 200..299
        response
      when 400
        raise BadRequestError, response
      when 401
        raise AuthorizationFailedError, response
      when 404
        raise NotFoundError, response
      when 422
        raise UnprocessableEntityError, response
      when 429
        raise TooManyRequestsError, response
      when 500
        raise InternalServerError, response
      else
        raise RequestError, response
      end
    end

    def request(method, uri, data = nil, options = {})
      request_options = add_custom_request_options(options)

      request_options[:headers]['Authorization'] = "Bearer #{@access_token}" if @access_token

      if data
        request_options[:headers]['Content-Type'] = 'application/json'
        request_options[:body] = JSON.dump(data)
      end

      HTTParty.send(method, uri, request_options)
    end

    def add_custom_request_options(custom_options)
      base_request_options.tap do |options|
        custom_options.each do |key, value|
          options[key] = value
        end
      end
    end

    def base_request_options
      {
        format: :json,
        headers: {
          'Accept' => 'application/json',
          'User-Agent' => USER_AGENT
        }
      }
    end
  end
end
