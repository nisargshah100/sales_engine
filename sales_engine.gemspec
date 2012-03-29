# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "sales_engine/version"

Gem::Specification.new do |s|
  s.name        = "sales_engine"
  s.version     = SalesEngine::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Jonan Scheffler", "Nisarg Shah"]
  s.email       = ["jonanscheffler+nisargshah100@gmail.com"]
  s.homepage    = ""
  s.summary     = %q{Sales Engine}
  s.description = %q{Hungry Academy Project}

  s.rubyforge_project = "sales_engine"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end
