require 'json'
require 'celluloid/websocket/client'

module RubyRoombot
  class Client
    include Celluloid
    include Celluloid::Logger

    attr_reader :connection

    def initialize(url)
      @connection = Celluloid::WebSocket::Client.new(url, current_actor)
    end

    def heartbeat
      send(topic: "phoenix", event: "heartbeat", payload: {}, ref: 10)
    end

    def join
      send({
        topic: "roomba",
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
    end

    def on_close(code, reason)
      debug("websocket connection closed: #{code.inspect}, #{reason.inspect}")
    end
  end
end
