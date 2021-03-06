module Alice

  class Bot

    attr_accessor :bot

    def initialize
      self.bot = Cinch::Bot.new do
        configure do |config|
          config.server = "irc.lonelyhackersclub.com"
          config.port = 2600
          config.channels = [ENV['PRIMARY_CHANNEL'], ENV['DEBUG_CHANNEL']]
          config.nick = "AliceBot_"
          config.user = "AliceBot"
          config.plugins.plugins = [
            Listeners::Setter,
            Listeners::Item,
            Listeners::Nlp,
            Listeners::Zork,
            Listeners::Beverage,
            Listeners::Score,
            Listeners::NumberWang,
            Listeners::Core,
            Listeners::TickTock
          ]
          config.password = ENV['USER_PASS']
          config.messages_per_second = 1
        end
      end
    end

    def join(channel_name)
      self.bot.join(channel_name)
    end

    def leave(channel_name)
      self.bot.channels.select{|c| c.name == channel_name}.first.part
    end

    def start
      self.bot.start
      self.bot
    end 

    def stop
      self.bot.stop
    end

  end

end

