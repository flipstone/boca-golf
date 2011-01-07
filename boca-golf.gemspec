# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "boca_golf/version"

Gem::Specification.new do |s|
  s.name        = 'boca-golf'
  s.version     = BocaGolf::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["David Vollbracht"]
  s.email       = ["david@flipstone.com"]
  s.homepage    = "https://github.com/flipstone/boca-golf"
  s.summary     = %q{A simple rspec-based engine for playing ruby golf coding problems}
  s.description = %q{boca-golf with securely load and run from the filesystem or a gist url,
execute a user-specified set of rspec examples against it, and also print of the score
(# number of charaters - lower == better!).  It was built for playing ruby golf at the
Boca Ruby Meetup sessions.
  }

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end
