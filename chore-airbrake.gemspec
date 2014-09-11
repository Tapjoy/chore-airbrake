# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'chore/airbrake/version'

Gem::Specification.new do |spec|
  spec.name          = "chore-airbrake"
  spec.version       = Chore::Airbrake::VERSION
  spec.authors       = ["Tapjoy"]
  spec.email         = ["eng-group-arch@tapjoy.com"]
  spec.summary       = "Airbrake integration for chore"
  spec.description   = "A repository for Airbrake integrations"
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency("chore")
  spec.add_development_dependency("airbrake")
  spec.add_development_dependency("rake")
  spec.add_development_dependency("rspec", ["~> 2.12.0"])
  spec.add_development_dependency("bundler", [">= 0"])
end
