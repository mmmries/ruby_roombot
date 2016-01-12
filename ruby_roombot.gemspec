# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'toetactics/version'

Gem::Specification.new do |spec|
  spec.name          = "toetactics"
  spec.version       = Toetactics::VERSION
  spec.authors       = ["mmmries"]
  spec.email         = ["michael@riesd.com"]

  spec.summary       = "A sample client for playing tic-tac-toe on http://games.riesd.com/"
  spec.description   = spec.summary
  spec.homepage      = "https://github.com/mmmries/toetactics"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.10"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.2"
  spec.add_runtime_dependency "celluloid-websocket-client", "~> 0.0.2"
  spec.add_runtime_dependency "thor", "~> 0.19"
end
