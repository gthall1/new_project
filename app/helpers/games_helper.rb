module GamesHelper
	def get_daily_leaderboard(args={})
		game_id = args[:game_id]
		game = Game.where(id:game_id).first
		if game
			UserGameSession.where(game_id:game.id).where.not(score:nil,score:0).where("created_at >= ?",Time.now.beginning_of_day).maximum(:score, :group=>'user_id').sort_by{|k,v| v}.reverse[0..9].map{ |a| [User.where(id:a[0]).first.present? ? User.find(a[0]).name : "Deleted" ,a[1]]}			
		end			
	end

	def get_weekly_leaderboard(args={})
		game_id = args[:game_id]
		game = Game.where(id:game_id).first
		if game
			UserGameSession.where(game_id:game.id).where.not(score:nil,score:0).where("created_at >= ?",Time.now.beginning_of_week).maximum(:score, :group=>'user_id').sort_by{|k,v| v}.reverse[0..9].map{ |a| [User.where(id:a[0]).first.present? ? User.find(a[0]).name : "Deleted" ,a[1]]}			
		end		
	end	

	def get_alltime_leaderboard(args={})
		game_id = args[:game_id]
		game = Game.where(id:game_id).first
		if game
			UserGameSession.where(game_id:game.id).where.not(score:nil,score:0).maximum(:score, :group=>'user_id').sort_by{|k,v| v}.reverse[0..9].map{ |a| [User.where(id:a[0]).first.present? ? User.find(a[0]).name : "Deleted" ,a[1]]}			
		end
	end	
end
