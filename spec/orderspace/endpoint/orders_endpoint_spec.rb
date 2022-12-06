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

  context 'get order' do
    it 'succeeds' do
      stub_request(:get, versioned_url('orders/or_l5DYqeDn'))
        .to_return(read_http_response_fixture('get_order/success.http'))

      client = Orderspace::Client.new(:my_token)
      order = client.orders.get_order('or_l5DYqeDn')

      expect(order.customer_id).to eql 'cu_gpbOljAn'
    end

    it 'no order with that id' do
      stub_request(:get, versioned_url('orders/42'))
        .to_return(read_http_response_fixture('get_order/no_order.http'))

      client = Orderspace::Client.new(:my_token)

      expect { client.orders.get_order('42') }.to raise_error(an_instance_of(Orderspace::NotFoundError).and(having_attributes(message: "Couldn't find order with id 42")))
    end
  end
end
