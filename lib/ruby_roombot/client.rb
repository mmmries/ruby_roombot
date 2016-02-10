require 'json'
require 'celluloid/websocket/client'

module RubyRoombot
  class Client
    include Celluloid
    include Celluloid::Logger

    attr_reader :connection, :channel

    def initialize(url, channel)
      @connection = Celluloid::WebSocket::Client.new(url, current_actor)
      @channel = channel
    end

    def heartbeat
      send(topic: "phoenix", event: "heartbeat", payload: {}, ref: 10)
    end

    def join
      send({
        topic: channel,
        event: "phx_join",
        payload: {},
        ref: 1,
      })
    end

    def on_open
      debug("websocket connection opened")
      join
    end

    def on_message(data)
      info("message: #{data.inspect}")
      decoded = ::JSON.parse(data)
      if decoded["event"] == "phx_reply" && decoded["ref"] == 1 #joined the topic
        shimmy
      end
    end

    def on_close(code, reason)
      debug("websocket connection closed: #{code.inspect}, #{reason.inspect}")
    end

    def shimmy(velocity = 20)
      10.times do
        send(topic: channel, event: "drive", ref: 15, payload: {velocity: velocity, radius: velocity/10})
        sleep 0.1
        send(topic: channel, event: "drive", ref: 15, payload: {velocity: velocity, radius: velocity/10 * -1})
        sleep 0.1
      end
      stop
    end

    def start(speed = 100)
      info("Start #{speed}")
      send(
        topic: channel,
        event: "drive",
        ref: 10,
        payload: {
          velocity: speed,
          radius: 0
        }
      )
    end

    def stop
      info("Stop")
      send(
        topic: channel,
        event: "drive",
        ref: 10,
        payload: {
          velocity: 0,
          radius: 0
        }
      )
    end

    def send(message)
      encoded = ::JSON.generate(message)
      if connection.text encoded
        info("sent: #{encoded}")
      else
        error("failed to send: #{encoded}")
      end
    end

    def turn_left(degrees = 90)
      info("Turn Left")
      interval = turn_degrees(degrees)
      send(topic: channel, event: "drive", ref: 15, payload: {velocity: 1, radius: 1})
      sleep interval
      stop
    end

    def turn_right(degrees = 90)
      info("Turn Left")
      interval = turn_degrees(degrees)
      send(topic: channel, event: "drive", ref: 15, payload: {velocity: 1, radius: -1})
      sleep interval
      stop
    end

  private

    def turn_degrees(degrees)
      ::Math::PI / (180 / degrees)
    end
  end
end
