# frozen_string_literal: true

module Orderspace
  class Endpoint

    ##
    # Contains the methods to interact with the orders endpoint.
    # @see https://apidocs.orderspace.com/#orders
    module Orders
      include Orderspace::Structs

      ##
      # Lists all the orders.
      #
      # You can pass in options like so:
      #
      # { query: { limit: 20 } }
      #
      # Check tho orderspace API documentation to know all the options available.
      #
      # @see https://apidocs.orderspace.com/#list-orders
      #
      # @return order_list [Orderspace::Structs::OrderList] a list of orders
      def list_orders(options = {})
        response = client.get('orders', options)
        Orderspace::Structs.from(JSON.parse(response.body), OrderList)
      end

      ##
      # Returns an order recognised by its id
      # @param order_id [String] the id of the order we want to get
      # @return order [Orderspace::Structs::Order] the order found
      def get_order(order_id)
        response = client.get("orders/#{order_id}")

        Orderspace::Structs.from(JSON.parse(response.body)['order'], Order)
      end
    end
  end
end
