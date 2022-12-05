# frozen_string_literal: true

require 'rspec'

describe Orderspace::Client::OauthEndpoint do

  before do
    stub_request(:post, 'https://identity.orderspace.com/oauth/token')
      .to_return(read_http_response_fixture('oauth/success.http'))
  end

  it 'obtains an access token' do
    client = Orderspace::Client.new
    client_id = 'client_id'
    client_secret = 'client_secret'

    oauth = client.oauth.obtain_access_token(client_id, client_secret)

    expect(oauth.access_token).to eql('wo983iaiaska092ao9y838')
    expect(oauth.token_type).to eql('Bearer')
    expect(oauth.expires_in).to eql(1800)
    expect(oauth.scope).to eql('read write')
  end
end
