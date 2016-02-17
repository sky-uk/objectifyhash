# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'hash_to_obj/version'

Gem::Specification.new do |spec|
  spec.name          = "hash_to_obj"
  spec.version       = HashToObj::VERSION
  spec.authors       = ["Arthur Silva"]
  spec.email         = ["arthur.silva@sky.uk"]

  spec.summary       = %q{This gem allows you to easily turn your hashes into objects}
  spec.description   = %q{This gem allows you to easily turn your hashes into objects, great for dealing with rest api's}
  spec.homepage      = "TODO: Put your gem's website or public repo URL here."
  spec.license       = "MIT"


  spec.files         = Dir.glob('**/*.rb') + %w[License.txt]

  spec.require_paths = ["lib"]

  spec.add_development_dependency "json", '~> 1.8'
  spec.add_development_dependency "minitest", '~> 5.8'
end
