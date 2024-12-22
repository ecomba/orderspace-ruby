# frozen_string_literal: true

module Orderspace
  class Endpoint
    ##
    # Contains the methods to interact with the customers endpoint.
    # @see https://apidocs.orderspace.com/#customers
    module Customers
      include Orderspace::Structs

      ##
      # Used to add a customer to your orderspace account
      #
      # @see https://apidocs.orderspace.com/#create-a-customer
      #
      # @param customer [Orderspace::Structs::Customer] The customer to be added
      # @return [Orderspace::Structs::Customer] The customer added (including the generated id)
      def create_customer(customer)
        response = client.post('customers', { customer: Orderspace::Structs.hashify(customer) })
        Orderspace::Structs.from(JSON.parse(response.body)['customer'], Customer)
      end

      ##
      # Lists all the customers in your account.
      #
      # You can pass in options like so:
      # { query: { starting_after: 'cu_53zjgvnm', limit: 1 } }
      #
      # Check tho orderspace API documentation to know all the options available.
      #
      # @see https://apidocs.orderspace.com/#list-customers
      #
      # @return customer_list [Orderspace::Structs::CustomerList] a list of customers
      def list_customers(options = {})
        response = client.get('customers', options)

        Orderspace::Structs.from(JSON.parse(response.body), CustomerList)
      end

      ##
      # Returns a customer searching by it's id
      # @param customer_id [String] the id of the customer we are looking for.
      # @return [Orderspace::Structs::Customer] The customer found
      def get_customer(customer_id)
        response = client.get("customers/#{customer_id}")

        Orderspace::Structs.from(JSON.parse(response.body)['customer'], Customer)
      end

      ##
      # Allows to edit the customer and change it's attributes
      # @param customer [Orderspace::Structs::Customer] the customer to be edited (note it must have it's id)
      def edit_customer(customer)
        response = client.put("customers/#{customer.id}", { customer: Orderspace::Structs.hashify(customer) })

        Orderspace::Structs.from(JSON.parse(response.body)['customer'], Customer)
      end
    end
  end
end
