# RubyRoombot

This is a little library that can act as a programmatic client for connecting to and driving [a roombot](http://roombots.riesd.com/).

To connect to the roombot simulator you would clone this repository and run a command like:

```
ruby -Ilib exe/ruby_roombot drive roombots.riesd.com --channel YOUR_UNIQUE_CHANNEL
```

To connect to a physical roombot you can use the default channel and just point to the IP address of the roombot:

```
ruby -Ilib exe/ruby_roombot drive 192.168.0.0.2
```

You will see a lot of output about the messages received and sent by this client so you can decide how to customize it.

## Customizing

Every time you get some sensor updates your `RubyRoombot::Client#on_message` method will be called with the message. Out of the box this method just logs the message, but you can change it to use that information to decide what driving commands you should send back to the roombot.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/toetactics. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

