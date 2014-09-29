# Chore::Airbrake

Airbrake integration support for Chore. Use this if reporting errors via Airbrake is part of your applications workflow.

Configure [Airbrake](http://airbrake.io) as suggested for your application.

That's it! The plugin registers itself with [Chore's hooks](https://github.com/tapjoy/chore#hooks) to report errors as they occur both in Chore itself and with your jobs.

## Installation

Add this line to your application's Gemfile:

    gem 'chore-airbrake'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install chore-airbrake

## Usage

Require 'chore/airbrake' when you're configuring chore for use in your application, and call the following:

```ruby
  Chore::Airbrake.register_airbrake_handlers!
```
