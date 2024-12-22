# frozen_string_literal: true

module Orderspace
  module Structs

    OauthCredentials = Struct.new(:access_token, :token_type, :expires_in, :scope)
  end
end