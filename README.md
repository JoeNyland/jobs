# Jobs

This is a little gem that works with jobs in a structure and manages their dependencies and execution order. 

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'jobs'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install jobs

## Usage

Require the gem in your code:
```ruby
require 'jobs'
```

### `Jobs#order`

```ruby
jobs = {
  a: nil,           # Job 'a' is not dependent on any other jobs, so it can be run on it's own
  b: :c,            # Job 'b' is dependent on job 'c' so job 'b' must be executed after job 'c'
  c: nil            # Job 'v' is not dependent on any other jobs, so it can be run on it's own
}
Jobs.new(jobs).to_s
 => "acb"
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/MasterRoot24/jobs. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

