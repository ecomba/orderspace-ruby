# frozen_string_literal: true

module Orderspace
  class Endpoint

    ##
    # Contains the methods to interact with the oauth endpoint.
    # @see https://apidocs.orderspace.com/#authentication
    module Oauth

      include Orderspace::Structs

      ##
      # Fetches the orderspace access token to interact with the Orderspace API
      # @param client_id [String] the client id as defined when the app was registered
      # @param client_secret [String] the client secret as defined when the app was registered
      # @return [Orderspace::Structs::OauthCredentials] the Oauth credentials containing the access token.
      def obtain_access_token(client_id, client_secret)
        response = client.request(:post, 'https://identity.orderspace.com/oauth/token',
                                  { client_id:, client_secret:, grant_type: 'client_credentials' })

        Orderspace::Structs.from(JSON.parse(response.body), OauthCredentials)
      end
    end
  end
end
