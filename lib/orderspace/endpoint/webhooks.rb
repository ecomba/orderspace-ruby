# frozen_string_literal: true

module Orderspace
  class Endpoint
    ##
    # Contains the methods to interact with the webhooks endpoint.
    # @see https://apidocs.orderspace.com/#webhooks
    module Webhooks
      include Orderspace::Structs

      ##
      # Creates a new webhook
      # @see https://apidocs.orderspace.com/#create-a-webhook
      # @param webhook [Orderspace::Structs::Webhook]
      # @return webhook [Orderspace::Structs::Webhook] the webhook with it's id
      def create(webhook)
        response = client.post('webhooks', { webhook: Orderspace::Structs.hashify(webhook) })
        parse_webhook response
      end

      ##
      # Lists all the webhooks you've registered
      # @see https://apidocs.orderspace.com/#list-webhooks
      # @return webhook_list [Orderspace::Struct::WebhookList]
      def list_webhooks
        response = client.get('webhooks')
        Orderspace::Structs.from(JSON.parse(response.body), WebhookList)
      end

      ##
      # Gets a webhook by it's id
      # @param id [String] the id of the webhook
      # @return webhook [Orderspace::Structs::Webhook] the webhook we were looking for
      def get_webhook(id)
        parse_webhook client.get("webhooks/#{id}")
      end

      ##
      # Updates the current webhook
      # @param webhook [Orderspace::Structs::Webhook] the webhook we want to update
      # @return webhook [Orderspace::Structs::Webhook] the updated webhook
      def update_webhook(webhook)
        parse_webhook client.put("webhooks/#{webhook.id}")
      end

      ##
      # Deletes the webhook
      # @param webhook [Orderspace::Structs::Webhook] the webhook we want to delete
      # @return webhook [Orderspace::Structs::Webhook] the deleted webhook (containing only the id and deleted (boolean))
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
