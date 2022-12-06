# frozen_string_literal: true

module Orderspace
  class Endpoint
    module Orders
      include Orderspace::Structs

      def list_orders(options = {})
        response = client.get('orders', options)
        Orderspace::Structs.from(JSON.parse(response.body), OrderList)
      end
    end
  end
end
