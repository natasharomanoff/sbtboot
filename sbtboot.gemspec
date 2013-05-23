# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'sbtboot/version'

Gem::Specification.new do |gem|
  gem.name          = "sbtboot"
  gem.version       = SbtBoot::VERSION
  gem.authors       = ["Natasha Romanoff"]
  gem.email         = ["black.widow@zoho.com"]
  gem.description   = %q{Generates sbt project}
  gem.summary       = %q{Generates sbt project}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]
end
