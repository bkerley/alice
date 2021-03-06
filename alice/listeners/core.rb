require 'cinch'

module Alice

  module Listeners

    class Core

      include Alice::Behavior::Listens
      include Alice::Behavior::TracksActivity
      include Cinch::Plugin

      match /^\!cast (.+)/,       method: :cast, use_prefix: false
      match /^\!cookie (.+)/,     method: :cookie, use_prefix: false
      match /^\!pants/,           method: :pants, use_prefix: false
      match /^\!help$/,           method: :help, use_prefix: false
      match /^\!source$/,         method: :source, use_prefix: false
      match /^\!bug$/,            method: :bug, use_prefix: false
      match /\<\.\</,             method: :shifty_eyes, use_prefix: false
      match /\>\.\>/,             method: :shifty_eyes, use_prefix: false
      match /rule[s]? them all/,  method: :bind_them, use_prefix: false
      match /say we all/,         method: :say_we_all, use_prefix: false
      match /.+/,                 method: :track_activity, use_prefix: false

      listen_to :nick, method: :update_nick
      listen_to :join, method: :maybe_say_hi

      def source(channel_user)
        Alice::Util::Mediator.reply_to(channel_user, "You can view my source at #{ENV['GITHUB_URL']}")
      end

      def track_activity(channel_user)
        track(channel_user.user.nick)
      end

      def cast(channel_user, spell)
        current_user = current_user_from(channel_user)
        if Alice::Util::Randomizer.one_chance_in(20)
          if weapon = Alice::Item.weapons.unclaimed.sample
            Alice::Place.current.items << weapon 
            current_user.score_point
            Alice::Util::Mediator.reply_to(channel_user, "#{weapon.name_with_article} appears at #{current_user.proper_name}'s feet!")
          end
        elsif Alice::Util::Randomizer.one_chance_in(20)
          if actor = Alice::Actor.all.sample
            Alice::Place.current.actors << actor 
            current_user.score_point
            Alice::Util::Mediator.reply_to(channel_user, "#{current_user.proper_name} magically appears before #{current_user.proper_name}!")
          end
        elsif Alice::Util::Randomizer.one_chance_in(5)
          current_user.items << Alice::Item.fruitcake
          current_user.penalize
          Alice::Util::Mediator.reply_to(channel_user, "#{current_user.proper_name} is rewarded with the fruitcake!")
        else
          Alice::Util::Mediator.reply_to(channel_user, Alice::Util::Randomizer.spell_effect(current_user.proper_name, spell))
        end
      end

      def bug(channel_user)
        Alice::Util::Mediator.reply_to(channel_user, "You can report bugs by visiting #{ENV['ISSUES_URL']}")
      end

      def bind_them(channel_user)
        Alice::Util::Mediator.emote_to(channel_user, "whispers, 'And in the darkness bind() them.'")
      end

      def cookie(channel_user, who)
        return unless Alice::User.find_or_create(who)
        Alice::Util::Mediator.emote_to(channel_user, "tempts #{who.proper_name} with a warm cookie.")
      end

      def frown(channel_user)
        return unless Alice::Util::Randomizer::one_chance_in(5)
        if observer == Alice::User.bot
          Alice::Util::Mediator.emote_to(channel_user, "#{observer.frown_with(channel_user.user.nick)}")
        else
          Alice::Util::Mediator.reply_to(channel_user, "#{observer.proper_name} #{observer.frown_with(channel_user.user.nick)}")
        end
      end

      def help(channel_user)
        Alice::Util::Mediator.reply_to(channel_user, "For most things you can tell me or ask me something in plain English.")
        Alice::Util::Mediator.reply_to(channel_user, "!bio sets your bio, !fact sets a fact about yoursef, !twitter sets your Twitter handle.")
        Alice::Util::Mediator.reply_to(channel_user, "!inventory, !forge, !brew, and !look can come in handy sometimes.")
        Alice::Util::Mediator.reply_to(channel_user, "Also: beware the fruitcake.")
      end

      def laugh(channel_user)
        return unless Alice::Util::Randomizer.one_chance_in(10)
        if observer == Alice::User.bot
          Alice::Util::Mediator.emote_to(channel_user, "#{observer.laugh_with(channel_user.user.nick)}")
        else
          Alice::Util::Mediator.reply_to(channel_user, "#{observer.proper_name} #{actor.laugh_with(channel_user.user.nick)}")
        end
      end

      def maybe_say_hi(channel_user)
        return if Alice::Util::Mediator.is_bot?(channel_user.user.nick)
        if Alice::User.with_nick_like(channel_user.user.nick)
          return unless Alice::Util::Randomizer.one_chance_in(10)
          Alice::Util::Mediator.emote_to(channel_user, Alice::Util::Randomizer.greeting(channel_user.user.nick))
        else #new user
          new_user = Alice::User.create(primary_nick: channel_user.user.nick)
          Alice::Util::Mediator.emote_to(channel_user, "greets the new hacker, #{channel_user.user.nick}!")  
        end
      end

      def pants(channel_user)
        if observer == Alice::User.bot
          Alice::Util::Mediator.emote_to(channel_user, "#{observer.laugh_with(channel_user.user.nick)}")
        else
          Alice::Util::Mediator.reply_to(channel_user, "#{observer.proper_name} #{observer.laugh_with(channel_user.user.nick)}")
        end
      end

      def say_we_all(channel_user)
        Alice::Util::Mediator.emote_to(channel_user, "solemny says, 'So say we all.'")
      end

      def scores(channel_user)
        Alice::Util::Mediator.reply_to(channel_user, Alice::Leaderboard.report)
      end

      def shifty_eyes(channel_user)
        return unless Alice::Util::Randomizer::one_chance_in(3)
        Alice::Util::Mediator.emote_to(channel_user, "thinks #{channel_user.user.nick} looks pretty shifty.")
      end

      def update_nick(channel_user)
        Alice::User.update_nick(channel_user.user.nick, channel_user.user.last_nick)
      end

    end

  end

end
