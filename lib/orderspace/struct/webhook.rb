# frozen_string_literal: true

module Orderspace
  module Structs
    Webhook = Struct.new(:id, :endpoint, :events, :signing_key, :deleted)

    WebhookList = Struct.new(:webhooks)
  end
end
