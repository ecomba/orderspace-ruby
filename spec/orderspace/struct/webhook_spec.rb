# frozen_string_literal: true

require 'rspec'

describe Orderspace::Structs::Webhook do
  context 'loading from json' do
    before do
      json = read_struct_fixture('webhook.json')
      @webhook = Orderspace::Structs.from(JSON.parse(json)['webhook'], Orderspace::Structs::Webhook)

    end

    it 'id' do
      expect(@webhook.id).to eql 'wh_1q4qn43v'
    end

    it 'endpoint' do
      expect(@webhook.endpoint).to eql 'https://webhook.site/6e3931ec-9f4b-4b3a-932f-42f73d1dc45f'
    end

    it 'events' do
      expect(@webhook.events).to eql %w[order.created dispatch.created]
    end

    it 'signing key' do
      expect(@webhook.signing_key).to eql 'UNxdW7ugYl8PCKjVGkoXkHARkCoFT3eXpdpDsF1s'
    end
  end
end
