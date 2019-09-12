# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'explicit_parameters/version'

Gem::Specification.new do |spec|
  spec.name          = 'explicit-parameters'
  spec.version       = ExplicitParameters::VERSION
  spec.authors       = ['Jean Boussier']
  spec.email         = ['jean.boussier@gmail.com']
  spec.summary       = %q{Explicit parameters validation and casting for Rails APIs}
  spec.homepage      = 'https://github.com/byroot/explicit-parameters'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split(?\0)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_dependency 'actionpack', '>= 6.0'
  spec.add_dependency 'activemodel', '>= 6.0'
  spec.add_dependency 'virtus', '~> 1.0'

  spec.add_development_dependency 'bundler'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
end
