# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'rpx/version'

Gem::Specification.new do |spec|
  spec.name          = "rpx"
  spec.version       = Rpx::VERSION
  spec.authors       = ["gregory"]
  spec.email         = ["greg2502@gmail.com"]
  spec.summary       = %q{RealPage Exchange Ruby Wrapper}
  spec.description   = %q{ruby client for the RealPageExchange SOAP API}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.5"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "rake"

  spec.add_dependency "savon", "~> 0.9.14"
end
