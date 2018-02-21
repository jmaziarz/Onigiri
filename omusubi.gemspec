# -*- encoding: utf-8 -*-
require File.expand_path('../lib/onigiri/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["robodisco"]
  gem.email         = ["adamsubscribe@googlemail.com"]
  gem.description   = %q{Heavy Duty Ingredient Parser}
  gem.summary       = %q{Heavy Duty Ingredient Parser}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "omusubi"
  gem.require_paths = ["lib"]
  gem.version       = Onigiri::VERSION

  gem.add_dependency 'redis'
  gem.add_dependency 'redis-namespace'

  gem.add_development_dependency "minitest"
  gem.add_development_dependency "simplecov"
  gem.add_development_dependency "pry"
  gem.add_development_dependency "m"
end
