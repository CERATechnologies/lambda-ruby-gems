# lambda-ruby-gems
Utility ruby gems for use with AWS Lambda

## Gems
                                             
This repo hosts several gems. See [this guide for how this is set up](https://medium.com/@mvinicius.zago/how-to-use-multiple-private-gems-in-the-same-github-repository-cab441bebfcb) ![](doc/images/ext-link.svg)

* `oculo-sns_events` -> [README](oculo-sns_events/README.md)

## Installation

Add this line to your application's Gemfile:

```ruby
source 'https://rubygems.oculo.io' do
  gem 'oculo-sns_events', '~> 0.1.1'  
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

## Infrastructure

In order to be used, the gems have to be built and published.

We host them on an S3 bucket (`s3://oculo-rubygems`) in the `shared-services` account. The buildkite build handles the building of the gems and updating of the bucket contents.

The bucket and the associated DNS and Cloudfront CDN (required for https) are managed from the `infrastructure/` directory.

To deploy changes to this, you will manually need to:

```bash
# Login to the AWS Docker repository 
aws-vault exec dev -- aws ecr get-login-password --region ap-southeast-2 | docker login --username AWS --password-stdin 644358627301.dkr.ecr.ap-southeast-2.amazonaws.com

aws-vault shared-services -- docker-compose run --rm infra
```

**Note** the resources are set up in the `us-west-1` region, as this is the only place SSL certificates for cloudfront can be provisioned.                                                                                            

There is a Route53 Hosted Zone for `rubygems.oculo.io` set up in the shared-services account. The `NS` records for this are then copied into the matching NS record for `oculo.io` on the production account.
