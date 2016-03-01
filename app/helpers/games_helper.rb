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
        version = args[:version] ||= nil
        game = Game.where(id:game_id).first
        users = []
        scores = []     
        if game
             if version.nil?
                game_sessions = UserGameSession.where(game_id:game.id).where("created_at >= ?",(Time.now - 1.week).beginning_of_day).where.not(score:nil,score:0).order("score desc")
             else
                game_sessions = UserGameSession.where(game_id:game.id,version:version).where("created_at >= ?",(Time.now - 1.week).beginning_of_day).where.not(score:nil,score:0).order("score desc")               
             end
            
            game_sessions.each do | u |
                next if users.include?(u.user_id)
                users << u.user_id
                scores << [User.where(id:u.user_id).first.present? ? User.find(u.user_id).name : "Deleted" ,u.score]
            end     
        end 
        scores[0..9]
    end 



    def get_friend_leaderboard(args={})
        game_id = args[:game_id]
        version = args[:version] ||= nil
        game = Game.where(id:game_id).first
        users = []
        scores = []     
        if game && current_user
            own_best_session = UserGameSession.where(game_id:game_id,version:version,user_id:current_user.id).order('score desc').first
            if own_best_session.blank?
                own_best_score = 0
            else
                own_best_score = own_best_session.score
            end
            scores << [current_user.name,current_user.oath_image,own_best_score]
            if session[:auth_token] 
                graph = Koala::Facebook::API.new(session[:auth_token]) 
                friends = graph.get_connections("me", "friends")  
                if !friends.blank? 
                    friends.each do | f | 
                        friend = User.where(uid:f["id"]).first 
                        if !friend.blank?
                            friend_best_session = UserGameSession.where(game_id:game_id,version:version,user_id:friend.id).order('score desc').first
                            if friend_best_session.blank?
                                friend_score = 0
                            else
                                friend_score = friend_best_session.score
                            end
                            scores << [friend.name,friend.oath_image,friend_score]
                        end 
                    end 
                end 
            end 
            
            # game_sessions.each do | u |
            #     next if users.include?(u.user_id)
            #     users << u.user_id
            #     scores << [User.where(id:u.user_id).first.present? ? User.find(u.user_id).name : "Deleted" ,u.score]
            # end     
        end 
        scores[0..9].sort_by {|k,v,l| l}.reverse!
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
    
    def get_current_highscore_for_version(args={})
         game_id = args[:game_id]
         version_id = args[:version_id]
         if UserGameSession.where(user_id:current_user.id,game_id:game_id,version:version_id).where.not(score: nil).order("score desc").present?
             return UserGameSession.where(user_id:current_user.id,game_id:game_id,version:version_id).where.not(score: nil).order("score desc").first.score
         else
             return 0
         end
     end
        
end
