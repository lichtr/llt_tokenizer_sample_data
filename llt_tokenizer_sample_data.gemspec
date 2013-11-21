# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'llt_tokenizer_sample_data/version'

Gem::Specification.new do |spec|
  spec.name          = "llt_tokenizer_sample_data"
  spec.version       = LltTokenizerSampleData::VERSION
  spec.authors       = ["lichtr"]
  spec.email         = ["robert.lichtensteiner@gmail.com"]
  spec.description   = %q{testing Perseus sample data with llt tokenization}
  spec.summary       = %q{testing Perseus sample data with llt tokenization}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "pry"
  spec.add_development_dependency 'array_scanner'
end
