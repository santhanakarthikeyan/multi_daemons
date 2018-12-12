# MultiDaemons

It provides an easy way to run multiple ruby scripts as daemon. Daemon can be controlled by start, stop and restart. It also supports blocks as daemons. It even supports running single daemon process like other popular daemonzing gems.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'multi_daemons'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install multi_daemons

## Usage
To run multiple daemons.

```ruby
# this is server.rb

proc_code = Proc do
  loop do
    sleep 5
  end
end

scheduler = MultiDaemons::Daemon.new('scripts/scheduler', name: 'scheduler', type: :script, options: {})
looper = MultiDaemons::Daemon.new(proc_code, name: 'looper', type: :proc, options: {})
MultiDaemons.runner([scheduler, looper], { force_kill_timeout: 60 })
```

Below are the commands supported
```ruby
ruby server.rb start
ruby server.rb stop
ruby server.rb restart
ruby server.rb status
```

To run single daemon within a script.
```ruby
proc_code = Proc do
  loop do
    sleep 5
  end
end
looper = MultiDaemons::Daemon.new(proc_code, name: 'looper', type: :proc, options: {})
looper.start # start daemon
# Do some other activity
looper.stop # stop daemon
```

To run single daemon.
```ruby
proc_code = Proc do
  loop do
    sleep 5
  end
end
looper = MultiDaemons::Daemon.new(proc_code, name: 'looper', type: :proc, options: {})
MultiDaemons.runner([looper], { force_kill_timeout: 60 })
```

We can even stop/start single daemon
```ruby
ruby server.rb start looper

or 

ruby server.rb stop looper
```


### Supported options for runner:
force_kill_timeout: <integer> # To kill all running daemons within the specified time.

### Supported option for Daemon:
force_kill_timeout, log_dir, pid_dir

### Error reporter

You may edit the error reporter to notify about any exception inside the daemon in a custom way. To notify Errbit or HoneyBadger use the following configuration

```ruby
MultiDaemons.error_reporters = [ proc { |exception, _worker, context_hsh| Airbrake.notify(exception, context_hsh) } ]

or 

MultiDaemons.error_reporters = [ proc { |exception, _worker, context_hsh| HoneyBadger.notify(exception, context_hsh) } ]
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the MultiDaemons project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/multi_daemons/blob/master/CODE_OF_CONDUCT.md).
