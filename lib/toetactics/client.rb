require 'json'
require 'celluloid/websocket/client'
require 'securerandom'

module Toetactics
  class Client
    include Celluloid
    include Celluloid::Logger

    attr_reader :ai, :client, :role, :token, :topic

    def initialize(uri, topic, ai)
      @ai = ai
      @client = Celluloid::WebSocket::Client.new(uri, current_actor)
      @counter = 0
      @role = nil
      @topic = topic
      @token = ::SecureRandom.hex(6)
      @game_over = false
    end

    def game_over?
      @game_over
    end

    def join
      message = {
        topic: topic,
        event: "phx_join",
        payload: {
          token: token,
          name: "Anonymous",
        }
      }
      if ai
        message[:payload][:ai] = ai
      end

      send(message)
    end

    def move(square)
      send({
        topic: topic,
        event: "move",
        payload: {
          token: token,
          square: square
        }
      })
    end

    def send(message)
      @counter += 1
      message[:ref] = @counter
      encoded = ::JSON.generate(message)
      if client.text encoded
        info("sent: #{encoded}")
      else
        error("failed to send: #{encoded}")
      end
    end

    def on_open
      debug("websocket connection opened")
    end

    def on_message(data)
      info("message: #{data.inspect}")
      decoded = ::JSON.parse(data)
      if decoded["ref"]
        handle_response(decoded)
      elsif decoded["event"] == "state"
        handle_state(decoded)
      elsif decoded["event"] == "game_over"
        handle_game_over(decoded)
      else
        error("UNKNOWN MESSAGE")
      end
    end

    def on_close(code, reason)
      debug("websocket connection closed: #{code.inspect}, #{reason.inspect}")
    end

  private

    def handle_game_over(msg)
      winner = msg["payload"]["winner"]
      info "#{winner} won the game"
      @game_over = true
      client.close
    end

    def handle_response(msg)
      if msg["payload"]["status"] == "ok"
        if msg["payload"]["response"]["role"]
          @role = msg["payload"]["response"]["role"]
          info "joined: you are #{@role}"
        end
      else
        error msg["payload"]["response"]
      end
    end

    def handle_state(msg)
    end
  end
end
