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

    def send(message)
      encoded = ::JSON.generate(message)
      if connection.text encoded
        info("sent: #{encoded}")
      else
        error("failed to send: #{encoded}")
      end
    end

    def on_open
      debug("websocket connection opened")
      join
    end

    def on_message(data)
      info("message: #{data.inspect}")
      decoded = ::JSON.parse(data)
      if decoded["event"] == "phx_reply" && decoded["ref"] == 1 #joined the topic
        send(topic: channel, event: "drive", ref: 15, payload: {velocity: 100, radius: 50})
      end
    end

    def on_close(code, reason)
      debug("websocket connection closed: #{code.inspect}, #{reason.inspect}")
    end
  end
end
