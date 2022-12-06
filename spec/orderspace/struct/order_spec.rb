# frozen_string_literal: true

require 'rspec'

describe Orderspace::Structs::Order do
  context 'loading from json' do
    before do
      json = read_struct_fixture('order.json')
      @order = Orderspace::Structs.from(JSON.parse(json)['order'], Orderspace::Structs::Order)
    end

    context 'validating correctness' do
      it 'id' do
        expect(@order.id).to eql 'or_l5DYqeDn'
      end

      it 'number' do
        expect(@order.number).to eql 1204
      end

      it 'shipping address' do
        expect(@order.shipping_address.city).to eql 'Bath'
      end

      it 'order lines' do
        order_lines = @order.order_lines

        expect(order_lines.length).to be 1
        expect(order_lines.first.sku).to eql 'AM-D-CHR-10'
      end

      it 'gross total' do
        expect(@order.gross_total).to eql 366.1
      end
    end
  end
end
