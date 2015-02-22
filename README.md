# ExplicitParameters

[![Build Status](https://secure.travis-ci.org/byroot/explicit-parameters.png)](http://travis-ci.org/byroot/explicit-parameters)
[![Gem Version](https://badge.fury.io/rb/explicit-parameters.png)](http://badge.fury.io/rb/explicit-parameters)


Explicit parameters validation and casting for Rails APIs.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'explicit-parameters'
```

And then execute:

    $ bundle

## Usage

Example:

```ruby
class DummyController < ApiController
  params do
    requires :search, String
    accepts :limit, Integer, default: 30

    validates :limit, :numericality: {greater_than: 0, less_than_or_equal_to: 100}
  end
  def index
    Dummy.search(params.search).limit(params.limit)
  end
end
```

## TODO

- Real README

## Contributing

1. Fork it ( https://github.com/byroot/explicit_parameters/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
