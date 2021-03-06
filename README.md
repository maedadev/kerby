# Kerby

Kubernetes ERB support on Yaml manifest files.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'kerby'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install kerby

## Usage

    $ kerby build [--node-yaml=NODE_YAML] MANIFEST-FILE... | kubectl apply -f -

## Description

                       +----------+
                       | node.yml |
                       +----------/
                            ↓
    +--------------+     +-------+     +---------+
    | manifest.yml | --> | kerby | --> | kubectl |
    +--------------/     +-------+     +---------+

Kerby is a preprocessor to parse input manifest.yml with ERB
(embeded ruby code) and generate to stdout for 'kubectl' manifest file.

'node.yml' is any type of parameter file to customize the manifest.yml.
For example, environment dependent parameter can be extracted to node.yml
to overwrite manifest.yml.

### Document

* [API Site](https://www.rubydoc.info/gems/kerby): Any ruby method can be embedded
  in ERB manifest file, as wells as
  {Kerby::Cli Kerby supporting methods} are also able to be used.
* [Gem Site](https://rubygems.org/gems/kerby)

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/maedadev/kerby. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/maedadev/kerby/blob/master/CODE_OF_CONDUCT.md).


## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Kerby project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/maedadev/kerby/blob/master/CODE_OF_CONDUCT.md).
