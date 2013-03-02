# -*- encoding: utf-8 -*-
require File.expand_path("../lib/hetzner/api/version", __FILE__)

Gem::Specification.new do |s|
  s.name        = "hetzner-api"
  s.version     = Hetzner::API::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ['Roland Moriz']
  s.email       = ['roland@moriz.de']
  s.homepage    = "http://moriz.de/opensource/hetzner-api"
  s.summary     = "A wrapper for Hetzner.de's server management API"
  s.description = "A wrapper for Hetzner.de's server management API"

  s.required_rubygems_version = ">= 1.3.6"
  s.rubyforge_project         = "hetzner-api"

  if RUBY_PLATFORM == 'java'
    s.add_runtime_dependency 'jruby-openssl'
  end

  s.add_dependency 'httparty', '~> 0.10.0'
  s.add_dependency 'thor'
  s.add_dependency 'json'
  s.add_dependency 'xml-simple'

  s.add_development_dependency "bundler"
  s.add_development_dependency "rspec",              "~> 2.12.0"
  s.add_development_dependency "guard-rspec",        "~> 2.3.1"
  s.add_development_dependency "fakeweb",            "~> 1.3.0"
  s.add_development_dependency "cucumber",           "~> 1.2.1"
  s.add_development_dependency "aruba"
  s.add_development_dependency "rake"
  s.add_development_dependency "coveralls"

  s.files        = `git ls-files`.split("\n")
  s.executables  = `git ls-files`.split("\n").map{|f| f =~ /^bin\/(.*)/ ? $1 : nil}.compact
  s.require_path = 'lib'
end
