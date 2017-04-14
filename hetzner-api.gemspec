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

  s.add_dependency 'httparty', '~> 0.14.0'
  s.add_dependency 'thor'
  s.add_dependency 'json'
  s.add_dependency 'xml-simple'

  s.files        = `git ls-files`.split("\n")
  s.executables  = `git ls-files`.split("\n").map{|f| f =~ /^bin\/(.*)/ ? $1 : nil}.compact
  s.require_path = 'lib'
end
