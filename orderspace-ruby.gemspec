# frozen_string_literal: true
$:.push File.expand_path('../lib', __FILE__)

require 'orderspace/version'

Gem::Specification.new do |spec|
  spec.name = 'orderspace-ruby'
  spec.version = Orderspace::VERSION
  spec.authors = ["Enrique Comba Riepenhausen"]
  spec.email = ["enrique@ecomba.pro"]

  spec.summary = 'Connect to your Orderspace API with ruby'
  spec.description = 'The orderspace ruby client allows you to connect to orderspace using Ruby'
  spec.homepage = 'https://github.com/ecomba/orderspace-ruby'
  spec.license = 'MIT'
  spec.required_ruby_version = '>= 3.1.2'

  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = spec.homepage
  spec.metadata['changelog_uri'] = "#{spec.homepage}/CHANGELOG.md"

  spec.files = Dir.chdir(__dir__) do
    `git ls-files -z`.split("\x0").reject do |f|
      (f == __FILE__) || f.match(%r{\A(?:(?:bin|test|spec|features)/|\.(?:git|travis|circleci)|appveyor)})
    end
  end

  spec.platform = Gem::Platform::RUBY
  spec.bindir = 'exe'
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency 'httparty', '0.20.0'
end
