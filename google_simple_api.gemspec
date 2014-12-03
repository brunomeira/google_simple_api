# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'google_simple_api/version'

Gem::Specification.new do |spec|
  spec.name          = "google-simple-api"
  spec.version       = GoogleSimpleApi::VERSION
  spec.authors       = ["Bruno Meira"]
  spec.email         = ["goesmeira@gmail.com"]
  spec.summary       = "Access data from Google APIs"
  spec.description   = "GoogleSimpleApi is a wrapper for Google APIs that makes it easy to access and receive data from it."
  spec.homepage      = "https://github.com/brunomeira/google-simple-api"
  spec.license       = "Apache 2.0"
  spec.required_ruby_version = '>= 1.9.3'

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "google-api-client", '~> 0.7'

  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "guard"
  spec.add_development_dependency "guard-rspec"
  spec.add_development_dependency "pry"
end
