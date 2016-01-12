require "thor"

module Toetactics
  class CLI < ::Thor
    class_option :url, :alias => [:u], :type => :string, :default => "ws://games.riesd.com/socket/websocket?vsn=1.0.0"
    class_option :ai, :type => :string, :default => "none"

    desc "play GAME_ID", "try to join and play a game of tic-tac-toe"
    def play(game_id)
      topic = "tictactoe:#{game_id}"
      client = Toetactics::Client.new(options[:url], topic, options[:ai])
      client.join

      until client.game_over? do
        client.move rand(0..8)
        sleep 1.0
      end
    end

    desc "loop GAME_ID", "try to join and play games of tic-tac-toe in a loop"
    def loop(game_id)
      topic = "tictactoe:#{game_id}"
      while true do
        client = Toetactics::Client.new(options[:url], topic, options[:ai])
        client.join

        until client.game_over? do
          puts "waiting for the game to end"
          client.move rand(0..8)
          sleep 1.0
        end
      end
    end
  end
end
