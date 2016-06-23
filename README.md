#ObjectifyHash
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
gem 'objectifyhash'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install objectifyhash

## Usage
you can call the method "to_obj" on hashes
or you can create your on class and include the module HashToObj, you can even setup exceptions and nullable keys.
See tests for complete use cases.

## More Information
Please check `/test/hash_to_obj_test.rb` we're going for a testing as documentation approach, if these are not clear, let us known

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake false` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/sky-uk/skystore-contrib-gem-objectifyhash
For more details check contributing.md

## License
BSD 3-Clause License
See License.txt


## Maintainers
awls99

## Motivation
Like most OSS, the motivation for the creation of this little gem was the fact that we had the need to do this, but there was nothing that did quite that out of the box, so we made our own.
While working with external API's, you usually get your parsed response in Hash format, which normally you do:
`user = response['user']`
but after the 500th time in deep nested array this starts becoming a pain:
 `movie_title = response['content']['movies'].first['properties']['title']`
And it becomes increasingly awkward to have pretty OOP methods to handle routine operations on the responses, you have to go with this ugly route:
```
movie              = get_random_movie_by_genre response['movie_list'], :Action
action_movie_title = extract_title movie #because movie is also a deep nested hash

```
BUT NO MORE with objectifyhash you can add this method to your MovieList class:
```
list               = MovieList.new response
movie              = list.genre(:Action).sample
action_movie_title = movie.title #because movie is not a Hash, but rather an instance of Movie which was created on the fly!
```
