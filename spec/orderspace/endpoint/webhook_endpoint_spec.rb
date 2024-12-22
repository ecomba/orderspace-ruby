# frozen_string_literal: true

require 'rspec'

describe Orderspace::Client::WebhooksEndpoint do
  context 'create webhook' do
    it 'success' do
      stub_request(:post, versioned_url('webhooks'))
        .to_return(read_http_response_fixture('create_webhook/success.http'))

      client = Orderspace::Client.new(:my_token)
      webhook_payload = Orderspace::Structs::Webhook.new.tap do |e|
        e.endpoint = 'https://webhook.site/6e3931ec-9f4b-4b3a-932f-42f73d1dc45f'
        e.events = %w[order.created dispatch.created]
      end

      webhook = client.webhooks.create(webhook_payload)

      expect(webhook.id).to eql 'wh_nq479yz6'
      expect(webhook.endpoint).to eql 'https://webhook.site/6e3931ec-9f4b-4b3a-932f-42f73d1dc45f'
      expect(webhook.events).to eql %w[order.created dispatch.created]
      expect(webhook.signing_key).to eql '7R2gNdE4GU8K06WXPV9lOXBic9mSs5LjKMsk46eW'
    end

    it 'fails' do
      stub_request(:post, versioned_url('webhooks'))
        .to_return(read_http_response_fixture('create_webhook/error.http'))

      client = Orderspace::Client.new(:my_token)

      webhook_payload = Orderspace::Structs::Webhook.new.tap do |e|
        e.events = %w[order.created dispatch.created]
      end

      expect do
        client.webhooks.create(webhook_payload)
      end.to raise_error(an_instance_of(Orderspace::UnprocessableEntityError).and(having_attributes(message: "Validation failed: Endpoint can't be blank, Endpoint must be a https url")))
    end
  end

  context 'listing webhooks' do
    it 'succeeds' do
      stub_request(:get, versioned_url('webhooks'))
        .to_return(read_http_response_fixture('list_webhooks/success.http'))

      client = Orderspace::Client.new(:my_token)

      webhooks = client.webhooks.list_webhooks

      expect(webhooks.webhooks.length).to eql 1

      expect(webhooks.webhooks.first.signing_key).to eql 'UNxdW7ugYl8PCKjVGkoXkHARkCoFT3eXpdpDsF1s'
    end
  end

  context 'getting a webhook' do
    it 'succeeds' do
      stub_request(:get, versioned_url('webhooks/wh_o9ernm4p'))
        .to_return(read_http_response_fixture('get_webhook/success.http'))

      client = Orderspace::Client.new(:my_token)
      webhook = client.webhooks.get_webhook('wh_o9ernm4p')

      expect(webhook.id).to eql 'wh_o9ernm4p'
      expect(webhook.endpoint).to eql 'https://webhook.site/6e3931ec-9f4b-4b3a-932f-42f73d1dc45f'
      expect(webhook.events).to eql %w[order.created dispatch.created]
      expect(webhook.signing_key).to eql 'UNxdW7ugYl8PCKjVGkoXkHARkCoFT3eXpdpDsF1s'
    end
  end

  context 'updating a webhook' do
    it 'succeeds' do
      stub_request(:put, versioned_url('webhooks/wh_o9ernm4p'))
        .to_return(read_http_response_fixture('update_webhook/success.http'))

      client = Orderspace::Client.new(:my_token)

      webhook = Orderspace::Structs::Webhook.new.tap do |e|
        e.id = 'wh_o9ernm4p'
        e.endpoint = 'https://webhook.site/6e3931ec-9f4b-4b3a-932f-42f73d1dc45f'
        e.events = %w[invoice.created]
      end

      updated_webhook = client.webhooks.update_webhook(webhook)

      expect(updated_webhook.id).to eql 'wh_o9ernm4p'
      expect(updated_webhook.endpoint).to eql 'https://webhook.site/6e3931ec-9f4b-4b3a-932f-42f73d1dc45f'
      expect(updated_webhook.events).to eql %w[invoice.created]
      expect(updated_webhook.signing_key).to eql 'UNxdW7ugYl8PCKjVGkoXkHARkCoFT3eXpdpDsF1s'
    end
  end

  context 'deleting a webhook' do
    it 'succeeds' do
      stub_request(:delete, versioned_url('webhooks/wh_o9ernm4p'))
        .to_return(read_http_response_fixture('delete_webhook/success.http'))

      client = Orderspace::Client.new(:my_token)

      webhook = Orderspace::Structs::Webhook.new.tap do |e|
        e.id = 'wh_o9ernm4p'
        e.endpoint = 'https://webhook.site/6e3931ec-9f4b-4b3a-932f-42f73d1dc45f'
        e.events = %w[invoice.created]
      end

      deleted_webhook = client.webhooks.delete_webhook(webhook)

      expect(deleted_webhook.id).to eql 'wh_o9ernm4p'
      expect(deleted_webhook.deleted).to be_truthy
    end
  end
end
