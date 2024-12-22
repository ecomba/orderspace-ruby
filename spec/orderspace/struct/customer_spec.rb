# frozen_string_literal: true

require 'rspec'

describe Orderspace::Structs::Customer do
  context 'to json' do
    before do
      address = Orderspace::Structs::Address.new.tap do |a|
        a.company_name = 'Blue Sky'
        a.contact_name = 'Emilia Jane Dogherty'
        a.line1 = '12 Blue Sky Lane'
        a.city = 'Bristol'
        a.postal_code = 'BS1 2DF'
        a.country = 'GB'
      end
      addresses = Array.new
      addresses.push address

      @customer = Orderspace::Structs::Customer.new.tap do |c|
        c.company_name = 'Blue Sky'
        c.status = 'active'
        c.phone = '555-744322'
        c.email_addresses = { orders: 'orders@beanmind.com', dispatches: 'dispatches@beanmind.com', invoices: 'invoices@beanmind.com'}
        c.addresses = addresses
      end
    end

    it 'is a hash' do
      hash = Orderspace::Structs.hashify(@customer)
      expect(hash).to be_a Hash
    end
  end

  context 'loading from json' do
    before do
      json = read_struct_fixture('customer.json')
      @customer = Orderspace::Structs.from(JSON.parse(json)['customer'], Orderspace::Structs::Customer)
    end

    context 'validating correctness' do
      it 'id' do
        expect(@customer.id).to eql 'cu_dnwz8gnx'
      end

      it 'company_name' do
        expect(@customer.company_name).to eql 'Blue Sky'
      end

      it 'created_at' do
        expect(@customer.created_at).to eql '2021-03-09T13:08:51Z'
      end

      it 'status' do
        expect(@customer.status).to eql 'active'
      end

      it 'reference' do
        expect(@customer.reference).to be_empty
      end

      it 'buyers' do
        expect(@customer.buyers).to be_a Array

        buyer = @customer.buyers.first

        expect(buyer.name).to eql 'Emilia Jane Dogherty'
        expect(buyer.email_address).to eql 'sample@orderspace.com'
      end

      it 'phone' do
        expect(@customer.phone).to eql '12345'
      end

      it 'email_addresses' do
        expect(@customer.email_addresses.fetch('orders')).to eql 'sample@orderspace.com'
        expect(@customer.email_addresses.fetch('dispatches')).to eql 'sample@orderspace.com'
        expect(@customer.email_addresses.fetch('invoices')).to eql 'sample@orderspace.com'
      end

      it 'tax_number' do
        expect(@customer.tax_number).to be_empty
      end

      it 'tax_rate_id' do
        expect(@customer.tax_rate_id).to be_nil
      end

      it 'addresses' do
        expect(@customer.addresses).to be_a Array

        address = @customer.addresses.first

        expect(address.company_name).to eql 'Blue Sky'
        expect(address.contact_name).to eql 'Emilia Jane Dogherty'
        expect(address.line1).to eql '12 Blue Sky Lane'
        expect(address.line2).to be_empty
        expect(address.city).to eql 'Bristol'
        expect(address.postal_code).to eql 'BS1 2DF'
        expect(address.state).to be_empty
        expect(address.country).to eql "GB"
      end

      it 'minimum_spend' do
        expect(@customer.minimum_spend).to eql 150.0
      end

      it 'payment_terms_id' do
        expect(@customer.payment_terms_id).to eql 'pt_zkmqv8e0'
      end

      it 'customer_group_id' do
        expect(@customer.customer_group_id).to eql 'cg_w2n6ln8v'
      end

      it 'price_list_id' do
        expect(@customer.price_list_id).to eql 'pr_3715yj58'
      end
    end

    context "validating" do
      before do
        @customer = Orderspace::Structs::Customer.new
      end

      it 'is invalid' do
        expect { Orderspace::Structs.validate(@customer) }.to raise_error(an_instance_of(Orderspace::ValidationFailedError).and(having_attributes(message: 'Validation failed: Company name cannot be blank')))
      end
    end
  end
end
