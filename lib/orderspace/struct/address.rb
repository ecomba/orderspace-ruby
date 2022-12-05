# frozen_string_literal: true

module Orderspace

  # mandatory: company name, contact name, line1, postcode country
  #
  module Structs
    Address = Struct.new(:company_name, :contact_name, :line1, :line2, :city, :postal_code, :state, :country)
  end
end