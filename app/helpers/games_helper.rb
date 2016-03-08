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

    # DEPRECATED: REMOVE AFTER TEST
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
                p session[:auth_token]
                graph = Koala::Facebook::API.new(session[:auth_token]) 
                if graph
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
            end 
            
            # game_sessions.each do | u |
            #     next if users.include?(u.user_id)
            #     users << u.user_id
            #     scores << [User.where(id:u.user_id).first.present? ? User.find(u.user_id).name : "Deleted" ,u.score]
            # end     
        end 
        scores[0..9].sort_by {|k,v,l| l}.reverse!
    end 

    #DEPRECATED REMOVE AFTER TEST
    def get_alltime_leaderboard(args={})
        game_id = args[:game_id]
        version = args[:version] ||= nil
        users = []
        scores = []
        @user_rank = nil
        game = Game.where(id:game_id).first

        if game
            if version.nil?
                game_sessions = UserGameSession.where(game_id:game.id).where.not(score:nil,score:0).order("score desc")
            else
                game_sessions = UserGameSession.where(game_id:game.id,version:version).where.not(score:nil,score:0).order("score desc")
            end
            game_sessions.each_with_index do | u,i |
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


    # def set_alltime_leaderboard_hash
    #     leaderboards = {}

    #     Game.where(device_type:[1,2,3]).each do | g | 
    #         leaderboards[g.slug] = get_game_ranks({game_id: g.id,slug: g.slug})
    #     end

    #     $redis.set 'all_time_leaderboard', leaderboards.to_json
    # end

    #current user all time record for specified timeframe
    def current_user_record(args ={})
        prefix = get_leaderboard_key_prefix({timeframe: args[:timeframe]})
        version = args[:version] ||= nil
        if $redis.get("#{prefix}_#{args[:slug]}_v#{version}_user_#{current_user.id}").blank?
            game_id = Game.where(slug:args[:slug]).first.id
            get_leaderboard_hash({slug:args[:slug],game_id: game_id,version: version, timeframe: args[:timeframe]})
        end

        #if redis key still blank, user hasnt played
        if $redis.get("#{prefix}_#{args[:slug]}_v#{version}_user_#{current_user.id}").blank?
            {"rank"=> "TBD", "score"=>"0"}
        else
            JSON.parse($redis.get("#{prefix}_#{args[:slug]}_v#{version}_user_#{current_user.id}"))
        end
    end

    def get_leaderboard_key_prefix(args={})
        case args[:timeframe]
            when 'alltime'
                prefix = 'at'
            when 'weekly'
                prefix = 'w'
            else
                prefix = 'at'
        end
    end

    def get_leaderboard_hash(args ={})
        game = Game.where(id:args[:game_id]).first
        timeframe = args[:timeframe] # 'alltime' | 'weekly'   
        prefix = get_leaderboard_key_prefix({timeframe: timeframe})
        return {} if game.nil?

        if $redis.get("#{prefix}_#{game.slug}_#{args[:version]}").blank? ||  JSON.parse($redis.get "#{prefix}_#{game.slug}_#{args[:version]}").blank?
            $redis.set "#{prefix}_#{game.slug}_#{args[:version]}", get_game_ranks({slug: game.slug,game_id: game.id,version: args[:version],timeframe: timeframe}).to_json
        end
         
        JSON.parse($redis.get "#{prefix}_#{game.slug}_#{args[:version]}")
    end

    # def set_game_ranks(args={})
    #     leaderboard = JSON.parse($redis.get 'all_time_leaderboard')
    #     game_ranks = leaderboard["#{args[:slug]}"]
    #     $redis.set 'all_time_leaderboard', 
    #     JSON.parse($redis.get 'all_time_leaderboard')["#{args[:slug]}"]
    # end

    #loop through users best game sessions and set ranks
    def get_game_ranks(args={}) 
        prefix = get_leaderboard_key_prefix({timeframe: args[:timeframe]})
        if args[:timeframe] == 'alltime'
            if args[:version].nil?
                rankings = UserGameSession.select('Max(score) as max_score,user_id').where(game_id:args[:game_id]).where.not(score: nil,score: 0).group("user_id").order('max_score desc')
            else
                rankings = UserGameSession.select('Max(score) as max_score,user_id').where(game_id:args[:game_id],version:args[:version]).where.not(score: nil,score: 0).group("user_id").order('max_score desc')
            end
        elsif args[:timeframe] == 'weekly'
            if args[:version].nil?
                rankings = UserGameSession.select('Max(score) as max_score,user_id').where(updated_at:(Time.now-1.week).beginning_of_day..Time.now).where(game_id:args[:game_id]).where.not(score: nil,score: 0).group("user_id").order('max_score desc')            
            else
                rankings = UserGameSession.select('Max(score) as max_score,user_id').where(updated_at:(Time.now-1.week).beginning_of_day..Time.now).where(game_id:args[:game_id],version:args[:version]).where.not(score: nil,score: 0).group("user_id").order('max_score desc')                            
            end
        end
        game_rank_hash = {}

        rankings.each.with_index(1) do | r, i | 
            $redis.set "#{prefix}_#{args[:slug]}_v#{args[:version]}_user_#{r.user_id}", { :rank => i, :score => r.max_score }.to_json
            game_rank_hash[i] = get_user_hash({user_id: r.user_id, score: r.max_score})
        end

        game_rank_hash
    end

    #set user data used in leaderboards
    def get_user_hash(args={})
        user = User.where(id:args[:user_id]).first
        image = '/assets/avatar-icon.png'
        score = args[:score]
        if user
            if !user.oath_image.blank?
                image = user.oath_image
            end
            { :id => user.id, :image => image, :score => score, :name => user.name }
        else
            { :id => args[:user_id], :image => image, :score => score, :name => "DELETED" }
        end
    end
end
