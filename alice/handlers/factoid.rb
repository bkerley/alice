module Alice

  module Handlers

    class Factoid

      def self.minimum_indicators
        3
      end

      def self.process(sender, command)
        if subject = Alice::User.from(command).sample
          if factoid = subject.factoids.sample
            Alice::Handlers::Response.new(content: factoid.formatted, kind: :reply)
          end
        else
          Alice::Handlers::Response.new(content: random.formatted, kind: :reply)
        end
      end

      def self.random
        Alice::Factoid.random
      end

    end

  end

end