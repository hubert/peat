# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'peat/version'

Gem::Specification.new do |spec|
  spec.name          = "peat"
  spec.version       = Peat::VERSION
  spec.authors       = ["Hubert Huang"]
  spec.email         = ["hhuang@practicefusion.com"]
  spec.summary       = %q{Wrapper for the Exact Target fuel api}
  spec.description   = %q{Wrapper for the Exact Target fuel api}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency 'faraday'
  spec.add_dependency 'faraday_middleware'
  spec.add_dependency 'activesupport'

  spec.add_development_dependency 'rspec'
  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "rake"
end
