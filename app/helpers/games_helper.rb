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
		users = []
		scores = []
		game = Game.where(id:game_id).first
		if game
			UserGameSession.where(game_id:game.id).where.not(score:nil,score:0).order("score desc").each do | u |
				next if users.include?(u.user_id)
				users << u.user_id
				scores << [User.where(id:u.user_id).first.present? ? User.find(u.user_id).name : "Deleted" ,u.score]
			end
		end
		scores[0..9]
	end	
end
