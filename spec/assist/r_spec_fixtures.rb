# frozen_string_literal: true

module RSpecFixtures
  def http_response(*names)
    join_file('responses.http', *names)
  end

  def read_http_response_fixture(*names)
    read_file(http_response(*names))
  end

  def struct(*names)
    join_file('structs', *names)
  end

  def read_struct_fixture(*names)
    read_file(struct(*names))
  end

  private

  def join_file(path, *names)
    File.join(SPEC_ROOT, path, *names)
  end

  def read_file(location)
    File.read(location)
  end

  def versioned_url(path)
    Orderspace::Client.versioned_url+path
  end
end

RSpec.configure do |config|
  config.include RSpecFixtures
end