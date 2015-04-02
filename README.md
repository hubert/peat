# Peat

Peat is a thin wrapper around the Exact Target Fuel Rest API, which abstracts away oauth token and connection management.
Currently, it only supports the use of Triggered Sends.

## Installation

Add this line to your application's Gemfile:

    gem 'peat'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install peat

## Usage

The Peat::TokenManager class depends on the gem-including app to set up a client id and secret for the Fuel API.
The gem will look for the these values in one of two places, ENV['FUEL_CLIENT_ID'] or $fuel_client_id and ENV['FUEL_SECRET'] or $fuel_secret,
for the fuel client id and secret respectively. Note if both the enviornment and global are set, the environment variable takes precedence.

If you're using a rails app, this could be configured in an intializer, e.g. config/initializers/peat.rb

```
ENV['FUEL_CLIENT_ID'] = 'yourclientid'
ENV['FUEL_SECRET'] = 'yoursecret'
```

or

```
$fuel_client_id = 'yourclientid'
$fuel_secret = 'yoursecret'
```

Typical usage is as so:

```
mail_params = {
  "From" => {
    "Address" => 'my_email@gmail.com',
    "Name" => 'Don Johnson',
  },
  "To" => {
    "Address" => 'my_friend@gmail.com',
    "SubscriberKey" => 'my_friend@gmail.com',
    "ContactAttributes" => {
      "SubscriberAttributes" => {
        'foo' => 'bar',
        'baz' => 'qux',
      }
    }
  }
}
peat_client = Peat::Client.deliver('name_of_my_triggered_send', mail_params)
```

## Contributing

1. Fork it 
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
