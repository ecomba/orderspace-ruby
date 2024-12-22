# frozen_string_literal: true

module Orderspace
  module Structs
    Order = Struct.new(:id, :number, :created, :status, :customer_id, :company_name, :phone, :email_addresses,
                       :delivery_date, :reference, :internal_note, :customer_po_number, :customer_note,
                       :standing_order_id, :shipping_type, :shipping_address, :billing_address, :order_lines,
                       :currency, :net_total, :gross_total)
    OrderLine = Struct.new(:id, :sku, :name, :options, :grouping_category, :shipping, :quantity, :unit_price,
                           :sub_total, :tax_name, :tax_rate, :tax_amount, :on_hold, :invoiced, :paid, :dispatched)
    OrderList = Struct.new(:orders, :has_more)
  end
end
