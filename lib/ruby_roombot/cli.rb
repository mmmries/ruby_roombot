require "thor"

module RubyRoombot
  class CLI < ::Thor
    option :channel, :default => "roomba"

    desc "drive ROOMBA_IP", "try to connect to and drive a roombot at the specified IP"
    def drive(roomba_ip)
      url = "ws://#{roomba_ip}/socket/websocket?vsn=1.0.0"
      client = RubyRoombot::Client.new(url, options[:channel])
      client.join

      loop do
        sleep 1.0
        client.heartbeat
      end
    end
  end
end
