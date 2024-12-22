# frozen_string_literal: true

module Orderspace
  ##
  # Basic Error
  class Error < StandardError
  end

  ##
  # For when a validation fails
  class ValidationFailedError < Error
  end

  ##
  # Basic Error representing the possible errors that can happen during our communication with the API.
  class RequestError < Error
    attr_reader :response, :message

    def initialize(response)
      @response = response
      super(message_from(response))
    end

    private

    def message_from(response)
      if contains_json?(response)
        @message = response['message']
      else
        "#{response.response.code} #{response.response.message}"
      end
    end

    def contains_json?(response)
      content_type = response.headers['Content-Type']
      content_type&.start_with?('application/json')
    end
  end

  ##
  # Generic (HTTP Status 400) error
  class BadRequestError < RequestError
  end

  ##
  # HTTP status 401 Error
  class AuthorizationFailedError < RequestError

    private

    def message_from(response)
      response.headers['www-authenticate'].to_s.split(/error_description=/, -1).last.delete('"')
    end
  end

  ##
  # HTTP status 404 Error
  class NotFoundError < RequestError
  end

  ##
  # HTTP status 422 Error
  class UnprocessableEntityError < RequestError
  end

  ##
  # HTTP status 429 error
  class TooManyRequestsError < RequestError
  end

  ##
  # Generic (HTTP Status 500) Error
  class InternalServerError < RequestError
  end
end
