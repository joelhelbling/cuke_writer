# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "cuke_writer/version"

Gem::Specification.new do |s|
  s.name        = "cuke_writer"
  s.version     = CukeWriter::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Joel Helbling"]
  s.email       = ["joel@joelhelbling.com"]
  s.homepage    = "http://github.com/joelhelbling/cuke_writer"
  s.summary     = %q{A custom Cucumber formatter which generates serialized sets of Cucumber features.}
  s.description = <<-EOF
CukeWriter basically creates features and scenarios which correspond directly
to the features and scenarios that generated them.
  EOF

  s.rubyforge_project = "cuke_writer"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_dependency 'cucumber', '>= 0.10.0'

  s.add_development_dependency 'rake',       '>= 0.9.2'
  s.add_development_dependency 'rspec',      '>= 2.6.0'
  s.add_development_dependency 'rspec-core', '>= 2.6.4'
  s.add_development_dependency 'aruba',      '>= 0.3.0'
end
