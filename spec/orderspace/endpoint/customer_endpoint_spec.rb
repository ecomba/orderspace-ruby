# frozen_string_literal: true

require 'rspec'

describe Orderspace::Client::CustomersEndpoint do
  context 'creating a customer' do
    it 'is successful' do
      stub_request(:post, versioned_url('customers'))
        .to_return(read_http_response_fixture('create_customer/success.http'))

      client = Orderspace::Client.new(:my_token)
      new_customer = Orderspace::Structs::Customer.new
      new_customer.company_name = 'Blue Sky'

      customer = client.customers.create_customer(new_customer)

      expect(customer.id).to eql 'cu_03dy67p3'
    end

    it 'is unsuccessful' do
      stub_request(:post, versioned_url('customers'))
        .to_return(read_http_response_fixture('create_customer/error.http'))

      client = Orderspace::Client.new(:my_token)
      endpoint = client.customers
      customer = Orderspace::Structs::Customer.new

      expect do
        endpoint.create_customer(customer)
      end.to raise_error(an_instance_of(Orderspace::UnprocessableEntityError).and(having_attributes(message: 'Validation failed: Email address has already been taken')))
    end
  end

  context 'listing customers' do
    it 'returns a list of the customers' do
      stub_request(:get, versioned_url('customers'))
        .to_return(read_http_response_fixture('list_customers/success.http'))

      client = Orderspace::Client.new(:my_token)

      response = client.customers.list_customers

      expect(response.customers.length).to eql 2

      expect(response.customers.first).to be_a Orderspace::Structs::Customer
      expect(response.customers.last.company_name).to eql 'Blue Sky'
      expect(response.has_more).to be_falsey
    end

    it 'accepts options' do
      stub_request(:get, versioned_url('customers?limit=1&starting_after=cu_53zjgvnm'))
        .to_return(read_http_response_fixture('list_customers/success.http'))

      client = Orderspace::Client.new(:my_token)

      client.customers.list_customers({ query: { starting_after: 'cu_53zjgvnm', limit: 1 } })
    end
  end

  context 'getting a single customer' do
    it 'is successful' do
      stub_request(:get, versioned_url('customers/cu_03dy67p3'))
        .to_return(read_http_response_fixture('get_customer/success.http'))

      customer_id = 'cu_03dy67p3'

      client = Orderspace::Client.new(:my_token)

      response = client.customers.get_customer(customer_id)

      expect(response).to be_a Orderspace::Structs::Customer
      expect(response.id).to eql customer_id
    end

    it "errs when the customer id doesn't match" do
      stub_request(:get, versioned_url('customers/_03dy67p3'))
        .to_return(read_http_response_fixture('get_customer/error.http'))

      customer_id = '_03dy67p3'

      client = Orderspace::Client.new(:my_token)

      expect do
        client.customers.get_customer(customer_id)
      end.to raise_error(an_instance_of(Orderspace::NotFoundError).and(having_attributes(message: "Couldn't find a customer with ID _03dy67p3")))
    end
  end

  context 'editing a customer' do
    it 'is successful' do
      stub_request(:put, versioned_url('customers/cu_03dy67p3'))
        .to_return(read_http_response_fixture('edit_customer/success.http'))

      customer = Orderspace::Structs::Customer.new
      customer.id = 'cu_03dy67p3'
      customer.company_name = 'COMP'

      client = Orderspace::Client.new(:my_token)

      response = client.customers.edit_customer(customer)

      expect(response.company_name).to eql 'COMP'
    end
  end
end
