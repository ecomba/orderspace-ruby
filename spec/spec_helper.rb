# frozen_string_literal: true
require 'rspec'

$:.unshift("#{File.dirname(__FILE__)}/lib")

require 'orderspace'

SPEC_ROOT = File.expand_path(__dir__) unless defined?(SPEC_ROOT)

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = '.rspec_status'

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end

Dir[File.join(SPEC_ROOT, "assist/**/*.rb")].each { |f| require f }
