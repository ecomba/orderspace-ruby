# frozen_string_literal: true

module Orderspace
  class Endpoint
    module Orders
      include Orderspace::Structs

      def list_orders(options = {})
        response = client.get('orders', options)
        Orderspace::Structs.from(JSON.parse(response.body), OrderList)
      end

      def get_order(order_id)
        response = client.get("orders/#{order_id}")

        Orderspace::Structs.from(JSON.parse(response.body)['order'], Order)
      end
    end
  end
end
