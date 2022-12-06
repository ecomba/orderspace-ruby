# frozen_string_literal: true

require 'rspec'

describe Orderspace::Client::OrdersEndpoint do

  context 'list orders' do
    it 'succeeds when there are no orders' do
      stub_request(:get, versioned_url('orders'))
        .to_return(read_http_response_fixture('list_orders/success_empty.http'))

      client = Orderspace::Client.new(:my_token)

      list = client.orders.list_orders

      expect(list.orders).to be_empty
      expect(list.has_more).to be_falsey
    end

    it 'succeeds with orders' do
      stub_request(:get, versioned_url('orders'))
        .to_return(read_http_response_fixture('list_orders/success.http'))

      client = Orderspace::Client.new(:my_token)

      list = client.orders.list_orders
      orders = list.orders

      expect(orders.length).to eql 1
      expect(orders.first.company_name).to eql 'Sample Customer'
    end
  end
end
