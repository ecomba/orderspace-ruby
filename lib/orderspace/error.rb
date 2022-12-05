# frozen_string_literal: true

module Orderspace
  class Error < StandardError
  end

  class ValidationFailedError < Error
  end

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

  class BadRequestError < RequestError
  end

  class AuthorizationFailedError < RequestError

    private

    def message_from(response)
      response.headers['www-authenticate'].to_s.split(/error_description=/, -1).last.delete('"')
    end
  end

  class NotFoundError < RequestError
  end

  class UnprocessableEntityError < RequestError
  end

  class TooManyRequestsError < RequestError
  end

  class InternalServerError < RequestError
  end
end
