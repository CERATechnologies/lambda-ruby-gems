# lambda-ruby-gems
Utility ruby gems for use with AWS Lambda

## Gems
                                             
This repo hosts several gems. See [this guide for how this is set up](https://medium.com/@mvinicius.zago/how-to-use-multiple-private-gems-in-the-same-github-repository-cab441bebfcb) ![](doc/images/ext-link.svg)

* `oculo-sns_events` -> [README](oculo-sns_events/README.md)

## Installation

Add this line to your application's Gemfile:

```ruby
# Replace 'ref' with, 'branch', 'tag', etc as appropriate 
git 'https://github.com/CERATechnologies/lambda-ruby-gems', ref: 'aaabbb33' do
  gem 'oculo-sns_events'  
end

```

And then execute:

```bash
bundle install
```

## Development

Each gem directory can be treated like its own project. Go into each directory and
       
```shell
bin/setup
rake spec
```

