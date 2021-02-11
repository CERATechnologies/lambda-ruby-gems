# frozen_string_literal: true

require_relative 'lib/oculo/sns_events/version'

Gem::Specification.new do |spec|
  spec.name          = 'oculo-sns_events'
  spec.version       = Oculo::SnsEvents::VERSION
  spec.license       = '(c) 2021 All Rights Reserved'
  spec.authors       = ['CT Operations Pty Ltd Trading As Oculo']
  spec.email         = ['developers@oculo.com.au']

  spec.summary       = 'Utility gems for use with AWS Lambda'
  spec.homepage      = 'https://github.com/CERATechnologies/lambda-ruby-gems'
  spec.required_ruby_version = Gem::Requirement.new('>= 2.6.5')

  spec.metadata['allowed_push_host'] = 'https://127.0.0.1/' #Nowhere

  spec.metadata['homepage_uri']    = spec.homepage
  spec.metadata['source_code_uri'] = 'https://github.com/CERATechnologies/lambda-ruby-gems'

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split('x0').reject { |f| f.match(%r{\A(?:test|spec|features)/}) }
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  # Uncomment to register a new dependency of your gem
  # spec.add_dependency "example-gem", "~> 1.0"

  # For more information and examples about making a new gem, checkout our
  # guide at: https://bundler.io/guides/creating_gem.html
end
