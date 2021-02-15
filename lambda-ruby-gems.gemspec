# frozen_string_literal: true

Gem::Specification.new do |spec|
  spec.platform                  = Gem::Platform::RUBY
  spec.name                      = 'lambda-ruby-gems'
  spec.version                   = '0.1.0'
  spec.summary                   = 'Utility gems for use with AWS Lambda'
  spec.description               = 'Utility gems for use with AWS Lambda'
  spec.required_ruby_version     = '>= 2.5.0'
  spec.required_rubygems_version = '>= 1.8.11'
  spec.license                   = '(c) 2021 All Rights Reserved'
  spec.author                    = 'CT Operations Pty Ltd Trading As Oculo'
  spec.email                     = ''
  spec.homepage                  = ''
  spec.files                     = ['README.md']

  spec.add_dependency 'bundler', '>= 2.0.0'

  spec.add_dependency "oculo-sns_events", '~> 0.1.0'

  spec.add_development_dependency 'rubocop', '~> 1.7'
end
