# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require_relative './lib/gocd/version.rb'

Gem::Specification.new do |s|
  s.name                        =   'gocd'
  s.version                     =   GOCD::VERSION
  s.summary                     =   'Get info from gocd using its apis'
  s.description                 =   s.summary
  s.authors                     =   ['Ajit Singh']
  s.email                       =   'jeetsingh.ajit@gamil.com'
  s.license                     =   'MIT'
  s.homepage                    =   'https://github.com/ajitsing/gocd.git'

  s.files                       =   `git ls-files -z`.split("\x0")
  s.executables                 =   s.files.grep(%r{^bin/}) { |f| File.basename(f)  }
  s.test_files                  =   s.files.grep(%r{^(test|spec|features)/})
  s.require_paths               =   ["lib"]

  s.add_dependency                  'activesupport'
  s.add_dependency                  'json'
  s.add_dependency                  'rest-client'
  s.add_dependency                  'cobravsmongoose', '~> 0.0.2'
  s.add_development_dependency      "bundler", "~> 1.5"
  s.add_development_dependency      "rspec"
end
