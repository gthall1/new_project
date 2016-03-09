task :fix_old_fb_names => :environment do | t, args |
    fb_users = User.where(provider:"facebook")
    fb_users.each do | u | 
        user = u 
        if user.name.include?(" ")
            user.name = user.name.gsub(" ","")
            user.name = user.name.downcase
            user.save
        end
    end
end


task :make_highscores => :environment do | t, args |
    if !Rails.env.production? 
        User.all.each do | u |
            Game.all.each do | g | 
                if true || u.user_game_sessions.where(game_id: g.id).blank?
                    random_score = rand(1000)
                    credits_earned = 0
                    version = nil
                    if g.slug == "tap-color"
                        version = rand(3)+1
                    end
                    $redis.del("at_#{g.slug}_#{version}")
                    $redis.del("w_#{g.slug}_#{version}")
                    UserGameSession.create({token:SecureRandom.urlsafe_base64,user_id:u.id,game_id:g.id,score:random_score,credits_earned:0,active:false,credits_applied:0,version:version,last_score_update:Time.now })
                end
            end
        end
        
    end
end

task :backfill_usersurvey_credits => :environment do | t, args |
    if !Rails.env.production? 
        Survey.all.each do | s |
            s.user_surveys.each do | us| 
                us.credits = s.credits
                us.save
            end
        end
    end
end
