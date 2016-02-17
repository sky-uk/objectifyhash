# HashToObj
This gem will allow you to turn ugly, bracket-hate inducing nested hashes into pretty objects.
Particularly usefull when dealing with REST api's
##Example
```
obj = {a:1, b:{c:2}}.to_obj
obj.a #=> 1
obj.b.c #=> 2
```
It deals well with nested arrays as well.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'hash_to_obj'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install hash_to_obj

## Usage
you can call the method "to_obj" on hashes
or you can create your on class and include the module HashToObj, you can even setup exceptions and nullable keys.
See tests for complete use cases.


## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake false` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/hash_to_obj.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

