# frozen_string_literal: true

require 'rspec'

describe 'Orderspace::Structs::Event' do
  before do
    json = read_struct_fixture('event.json')
    @events = Orderspace::Structs.from(JSON.parse(json), Orderspace::Structs::Event)
  end

  after do
    # Do nothing
  end

  context 'reading data' do
    it 'has two events' do
      expect(@events.length).to eql 2
    end

    it 'has an order' do
      event = @events.first

      expect(event.event).to eql 'order.created'
      expect(event.data).to be_a Orderspace::Structs::Order
    end

    it 'has a customer' do
      event = @events.last

      expect(event.event).to eql 'customer.created'
      expect(event.data).to be_a Orderspace::Structs::Customer
    end
  end
end
