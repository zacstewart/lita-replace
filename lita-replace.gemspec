Gem::Specification.new do |spec|
  spec.name          = "lita-replace"
  spec.version       = "0.0.1"
  spec.authors       = ["Zac Stewart"]
  spec.email         = ["zgstewart@gmail.com"]
  spec.description   = %q{A Lita handler that fixes your stupid typos with VIM-like find and replace.}
  spec.summary       = %q{A Lita handler that fixes your stupid typos with VIM-like find and replace.}
  spec.homepage      = "https://github.com/zacstewart/lita-replace"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "lita", "~> 2.5"

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec", ">= 2.14"
  spec.add_development_dependency "simplecov"
  spec.add_development_dependency "coveralls"
end
