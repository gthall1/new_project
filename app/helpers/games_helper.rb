module GamesHelper
    def get_daily_leaderboard(args={})
        game_id = args[:game_id]
        game = Game.where(id:game_id).first
        users = []
        scores = []     
        if game
            UserGameSession.where(game_id:game.id).where("created_at >= ?",Time.now.beginning_of_day).where.not(score:nil,score:0).order("score desc").each do | u |
                next if users.include?(u.user_id)
                users << u.user_id
                scores << [User.where(id:u.user_id).first.present? ? User.find(u.user_id).name : "Deleted" ,u.score]
            end     
        end 
        scores[0..9]                
    end

    def get_weekly_leaderboard(args={})
        game_id = args[:game_id]
        game = Game.where(id:game_id).first
        users = []
        scores = []     
        if game
            UserGameSession.where(game_id:game.id).where("created_at >= ?",(Time.now - 1.week).beginning_of_day).where.not(score:nil,score:0).order("score desc").each do | u |
                next if users.include?(u.user_id)
                users << u.user_id
                scores << [User.where(id:u.user_id).first.present? ? User.find(u.user_id).name : "Deleted" ,u.score]
            end     
        end 
        scores[0..9]
    end 

    def get_alltime_leaderboard(args={})
        game_id = args[:game_id]
        version = args[:version] ||= nil
        users = []
        scores = []
        game = Game.where(id:game_id).first
        if game
            if version.nil?
                game_sessions = UserGameSession.where(game_id:game.id).where.not(score:nil,score:0).order("score desc")
            else
                game_sessions = UserGameSession.where(game_id:game.id,version:version).where.not(score:nil,score:0).order("score desc")
            end
            game_sessions.each do | u |
                next if users.include?(u.user_id)
                users << u.user_id
                scores << [User.where(id:u.user_id).first.present? ? User.find(u.user_id).name : "Deleted" ,u.score]
            end
        end
        scores[0..9]
    end 
 

    def get_current_highscore(args={})
        game_id = args[:game_id]
        if UserGameSession.where(user_id:current_user.id,game_id:game_id).where.not(score: nil).order("score desc").present?
            return UserGameSession.where(user_id:current_user.id,game_id:game_id).where.not(score: nil).order("score desc").first.score
        else
            return 0
        end
    end
    
    
end
