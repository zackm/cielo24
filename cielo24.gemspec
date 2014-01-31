# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'cielo24/version'

Gem::Specification.new do |spec|
  spec.name          = "cielo24"
  spec.version       = Cielo24::VERSION
  spec.authors       = ["Alan Johnson"]
  spec.email         = ["alan@teamtreehouse.com"]
  spec.description   = %q{Library for submitting and requesting captions from Cielo24.}
  spec.summary       = %q{Submit and request captions through Cielo24.}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec", "~> 2.14.1"
  
  spec.add_dependency "httpclient", "~> 2.3.4.1"  
end
