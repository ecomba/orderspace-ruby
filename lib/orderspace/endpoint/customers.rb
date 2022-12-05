# frozen_string_literal: true

module Orderspace
  class Endpoint
    module Customers
      include Orderspace::Structs
      def create_customer(customer)
        response = client.post('customers', { customer: Orderspace::Structs.to_json(customer) })
        Orderspace::Structs.from(JSON.parse(response.body)['customer'], Customer)
      end

      def list_customers(options = {})
        response = client.get('customers', options)

        Orderspace::Structs.from(JSON.parse(response.body), CustomerList)
      end

      def get_customer(customer_id)
        response = client.get("customers/#{customer_id}")

        Orderspace::Structs.from(JSON.parse(response.body)['customer'], Customer)
      end

      def edit_customer(customer)
        response = client.put("customers/#{customer.id}", { customer: Orderspace::Structs.to_json(customer) })

        Orderspace::Structs.from(JSON.parse(response.body)['customer'], Customer)
      end

    end
  end
end
