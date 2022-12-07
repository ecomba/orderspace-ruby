# frozen_string_literal: true

module Orderspace
  class Endpoint
    module Webhooks
      include Orderspace::Structs

      def create(webhook)
        response = client.post('webhooks', { webhook: Orderspace::Structs.hashify(webhook) })
        parse_webhook response
      end

      def list_webhooks
        response = client.get('webhooks')
        Orderspace::Structs.from(JSON.parse(response.body), WebhookList)
      end

      def get_webhook(id)
        parse_webhook client.get("webhooks/#{id}")
      end

      def update_webhook(webhook)
        parse_webhook client.put("webhooks/#{webhook.id}")
      end

      def delete_webhook(webhook)
        parse_webhook client.delete("webhooks/#{webhook.id}")
      end

      private
      def parse_webhook(response)
        Orderspace::Structs.from(JSON.parse(response.body)['webhook'], Webhook)
      end
    end
  end
end
