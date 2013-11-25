# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'duyoji_todo/version'

Gem::Specification.new do |spec|
  spec.name          = "duyoji_todo"
  spec.version       = DuyojiTodo::VERSION
  spec.authors       = ["Tsuyoshi Maeda"]
  spec.email         = ["oasis5tsuyoshi@gmail.com"]
  spec.description   = %q{Perfect Ruby chapter15}
  spec.summary       = %q{Perfect Ruby chapter15}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler",   "~> 1.3"
  spec.add_development_dependency "rake",      "~> 10.0"
  spec.add_development_dependency "yard",      "~> 0.8"
  spec.add_development_dependency "redcarpet", "~> 2.2"
end
