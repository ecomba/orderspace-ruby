# frozen_string_literal: true

require_relative '../endpoints'

module Orderspace
  class Endpoint

    module Oauth

      include Orderspace::Structs

      def obtain_access_token(client_id, client_secret)
        response = client.request(:post, 'https://identity.orderspace.com/oauth/token',
                                  { client_id:, client_secret:, grant_type: 'client_credentials' })

        Orderspace::Structs.from(JSON.parse(response.body), OauthCredentials)
      end
    end
  end
end
