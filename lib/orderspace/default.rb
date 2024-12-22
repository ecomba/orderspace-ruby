# frozen_string_literal: true

module Orderspace
  ##
  # Module to compile the default settings
  module Default

    # Default Orderspace API endpoint
    BASE_URL = 'https://api.orderspace.com/'

    # Default User-Agent header
    USER_AGENT = "beanmind-orderspace-ruby/#{VERSION}".freeze
  end
end
