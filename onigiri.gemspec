# -*- encoding: utf-8 -*-
require File.expand_path('../lib/onigiri/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["robodisco"]
  gem.email         = ["adamsubscribe@googlemail.com"]
  gem.description   = %q{TODO: Write a gem description}
  gem.summary       = %q{TODO: Write a gem summary}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "onigiri"
  gem.require_paths = ["lib"]
  gem.version       = Onigiri::VERSION

  gem.add_development_dependency "minitest"
  gem.add_development_dependency "simplecov"
  gem.add_development_dependency "pry"
  gem.add_development_dependency "m"
end
