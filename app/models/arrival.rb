class Arrival < ActiveRecord::Base

    def get_highscore(args={})
        version = args[:version]
        case args[:timeframe]
            when 'weekly'
                prefix = 'w'
            when 'alltime'
                prefix = 'at'
            else 
                prefix = 'at'
        end

        if $redis.get("#{prefix}_#{args[:slug]}_v#{version}_#{self.global_visitor_id}")
            return JSON.parse($redis.get("#{prefix}_#{args[:slug]}_v#{version}_#{self.global_visitor_id}"))["score"]
        else
            game = Game.where(slug:args[:slug]).first
            return UserGameSession.where(arrival_id:self.id,game_id:game.id,version:version).where.not(score: nil).order("score desc").first.score if UserGameSession.where(arrival_id:self.id,game_id:game.id).where.not(score: nil).order("score desc").present?
        end

        return 0
    end
end
