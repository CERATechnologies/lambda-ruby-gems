# Oculo::SnsEvents

## Installation

Add this line to your application's Gemfile:

```ruby
# Replace 'ref' with, 'branch', 'tag', etc as appropriate 
git 'https://github.com/CERATechnologies/lambda-ruby-gems', ref: 'aaabbb33' do
  gem 'oculo-sns_events'  
end

```

And then execute:

```shell
$ bundle install
```

## Usage

```ruby
  require 'oculo/sns_events' 

  s3_event = Oculo::SnsEvents::S3Notification.new(event: event)
  return unless s3_event.has_path?('/my/path') && s3_event.matches_extensions?('.jpg', '.jpeg')
  do_something(s3_event.payload)
  ...
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

