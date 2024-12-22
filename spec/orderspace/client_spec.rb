# frozen_string_literal: true

require 'rspec'

describe Orderspace::Client do
  context 'configuration' do
    it 'orderspace API version' do
      expect(Orderspace::Client::API_VERSION).to eql 'v1'
    end

    it 'header authorization' do
      expect(Orderspace::Client::HEADER_AUTHORIZATION).to eql 'Authorization'
    end
  end

  context 'uri' do
    it 'the base url' do
      expect(Orderspace::Client.base_url).to eql 'https://api.orderspace.com/'
    end

    it 'the versioned url' do
      expect(Orderspace::Client.versioned_url).to eql 'https://api.orderspace.com/v1/'
    end

    it 'constructs the right uri when passing the path' do
      response = double(:response)
      options = { format: :json,
                  headers: {
                    'Accept' => 'application/json',
                    'User-Agent' => 'beanmind-orderspace-ruby/0.1.0'
                  }
      }
      allow(response).to receive(:code).and_return 200
      expect(HTTParty).to receive(:send).with(:get, 'https://api.orderspace.com/v1/customers', options)
                                        .and_return(response)

      Orderspace::Client.new.get('customers')
    end
  end

  context 'http verbs' do
    it 'can get' do
      allow(subject).to receive(:execute).with(:get, 'path', nil, {}).and_return(:returned)
      expect(subject.get('path')).to eq(:returned)
    end

    it 'can post' do
      allow(subject).to receive(:execute).with(:post, 'path', { foo: 'bar' }, {}).and_return(:returned)
      expect(subject.post('path', { foo: 'bar' })).to eq(:returned)
    end
  end

  context 'errors' do
    it 'bad request' do
      stub_request(:post, 'https://api.orderspace.com/v1/somewhere_bad')
        .to_return(read_http_response_fixture('bad_request.http'))

      expect { Orderspace::Client.new.post('somewhere_bad') }.to raise_error(Orderspace::BadRequestError)
    end

    it 'unauthorized' do
      stub_request(:post, 'https://api.orderspace.com/v1/customers')
        .to_return(read_http_response_fixture('unauthorized.http'))

      expect { Orderspace::Client.new.post('customers') }.to raise_error(Orderspace::AuthorizationFailedError)
    end

    it 'token expired' do
      stub_request(:post, 'https://api.orderspace.com/v1/customers')
        .to_return(read_http_response_fixture('token_expired.http'))

      expect { Orderspace::Client.new.post('customers') }.to raise_error(Orderspace::AuthorizationFailedError)
    end

    it 'not found' do
      stub_request(:post, 'https://api.orderspace.com/v1/somepage')
        .to_return(read_http_response_fixture('not_found.http'))

      expect { Orderspace::Client.new.post('somepage') }.to raise_error(Orderspace::NotFoundError)
    end

    it 'unprocessable entity' do
      stub_request(:post, 'https://api.orderspace.com/v1/customers')
        .to_return(read_http_response_fixture('unprocessable_entity.http'))

      expect { Orderspace::Client.new.post('customers') }.to raise_error(an_instance_of(Orderspace::UnprocessableEntityError).and having_attributes(message: 'Validation failed: Payment Terms are invalid, Customer Group is invalid'))
    end
  end

  context 'initialization' do
    it 'with client_id and client_secret adds the access token to the client' do
      stub_request(:post, 'https://identity.orderspace.com/oauth/token')
        .to_return(read_http_response_fixture('oauth/success.http'))

      client = Orderspace::Client.with(:client_id, :client_secret)

      expect(client).to be_a Orderspace::Client
      expect(client.access_token).to eql 'wo983iaiaska092ao9y838'
    end
  end

  context 'endpoints' do
    it 'returns the oauth client' do
      expect(Orderspace::Client.new.oauth).to be_a Orderspace::Endpoint::Oauth
    end

    it 'returns the customers client' do
      expect(Orderspace::Client.new.customers).to be_a Orderspace::Endpoint::Customers
    end
  end
end
