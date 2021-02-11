# frozen_string_literal: true

Gem::Specification.new do |s|
  s.platform                  = Gem::Platform::RUBY
  s.name                      = 'lambda-ruby-gems'
  s.version                   = '0.1'
  s.summary                   = 'Utility gems for use with AWS Lambda'
  s.description               = 'Utility gems for use with AWS Lambda'
  s.required_ruby_version     = '>= 2.6.5'
  s.required_rubygems_version = '>= 3.0.0'
  s.license                   = '(c) 2021 All Rights Reserved'
  s.author                    = 'CT Operations Pty Ltd Trading As Oculo'
  s.email                     = ''
  s.homepage                  = ''
  s.files                     = ['README.md']
  s.add_dependency 'bundler', '>= 2.2.0'
  s.add_dependency "oculo-sns_events"
end
