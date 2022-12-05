# frozen_string_literal: true

module Orderspace
  # mandatory company_name, login_email? contact_name, address (company name, contact name, line1, postcode country)
  module Structs
    Customer = Struct.new(:id, :company_name, :created_at, :status, :reference, :buyers, :phone, :email_addresses,
                          :tax_number, :tax_rate_id, :addresses, :minimum_spend, :payment_terms_id,
                          :customer_group_id, :price_list_id)

    CustomerList = Struct.new(:customers, :has_more)

    class CustomerValidator
      def self.validate(customer)
        return unless customer.company_name.nil?

        raise ValidationFailedError, 'Validation failed: Company name cannot be blank'
      end
    end
  end
end
