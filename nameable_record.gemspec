# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "nameable_record/version"

Gem::Specification.new do |s|
  s.name        = "nameable_record"
  s.version     = NameableRecord::VERSION
  s.authors     = ["Jason Harrelson"]
  s.email       = ["jason@lookforwardenterprises.com"]
  s.homepage    = "https://github.com/midas/nameable_record"
  s.summary     = %q{Abstracts the ActiveRecord composed_of pattern for names.}
  s.description = %q{Abstracts the ActiveRecord composed_of pattern for names.  Also provides other convenience utilieis for working with human names.}
  s.license     = "MIT"

  s.rubyforge_project = "nameable_record"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  # specify any dependencies here; for example:
  %w(
    gem-dandy
    rspec
    rails
  ).each do |development_dependency|
    s.add_development_dependency development_dependency
  end

  # s.add_runtime_dependency "rest-client"
end

