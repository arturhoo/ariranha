# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'ariranha/version'

Gem::Specification.new do |spec|
  spec.name = 'ariranha'
  spec.version = Ariranha::VERSION
  spec.authors = ['Artur Rodrigues']
  spec.email = ['arturhoo@gmail.com']
  spec.description = 'Backs up databases and sends them to multiple clouds'
  spec.summary = 'Backs up databases and sends them to multiple clouds'
  spec.homepage = 'https://github.com/arturhoo/ariranha'
  spec.license = 'MIT'

  spec.files = `git ls-files`.split($INPUT_RECORD_SEPARATOR)
  spec.executables = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.10'
  spec.add_development_dependency 'pry-byebug'

  spec.add_dependency 'fog'
end
