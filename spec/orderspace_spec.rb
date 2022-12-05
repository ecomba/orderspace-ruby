# frozen_string_literal: true
require 'rspec'

describe Orderspace do
  it 'has a version number' do
    expect(Orderspace::VERSION).not_to be nil
  end

  it 'has a base url' do
    expect(Orderspace::Default::BASE_URL).to eql('https://api.orderspace.com/')
  end

  it 'has a user agent' do
    expect(Orderspace::Default::USER_AGENT).to eql("beanmind-orderspace-ruby/#{Orderspace::VERSION}")
  end
end
