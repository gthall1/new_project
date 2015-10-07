require 'rake'

task :seed_data => :environment do |t,args|

	#SEED TESTGAME
	testgame = Game.new
	testgame.name = "Test"
	testgame.save

	#SEED HELICOPTER GAME
	heligame = Game.new
	heligame.name = "Helicopter"
	heligame.save

    #SEED MEMORY GAME
	memory = Game.new
	memory.name = "Memory Game"
	memory.save

	#SEED ADVERTISERS
	10.times do | i |
		a = Advertiser.new
		a.name = "Advertiser #{i}"
		a.logo = "#{i}.jpg"
		a.save
	end

    #SEED JACKPOT
	jackpot = Jackpot.new
	jackpot.name = "Test"
	jackpot.draw_date = Time.now + 2.months
	jackpot.open = true
	jackpot.prize = "$100 visa giftcard"
	jackpot.max_entries = 500
	jackpot.save
end

task :add_referal_to_users  => :environment do | t, args |
   User.all.each do | u |
      u.create_referral_code
      u.save
   end
end

task :seed_games => :environment do | t, args |
  require 'net/http'
   source = 'http://api.famobi.com/feed/'
   resp = Net::HTTP.get_response(URI.parse(source))
   data = resp.body
   result = JSON.parse(data)
   a = GameCategory.all
   a.destroy_all
   result["categories"].each_with_index do | c,i |
   	cat = GameCategory.new
   	cat.id = i+1
   	cat.name = c
   	cat.save
   end
   b = FeedGame.all
   b.destroy_all
   result["games"].each do | g |
   	game = FeedGame.new
   	game.name = g["name"]
   	game.description = g["description"]
   	game.thumb_60 = g["thumb_60"]
   	game.thumb_120 = g["thumb_120"]
   	game.thumb_180 = g["thumb_180"]

   	game.save
   	g["categories"].each do | c|
   		gc = GameCategoryRel.new
   		gc.feed_game_id = game.id
   		gc.category_id = GameCategory.where(name:c[1])
   		gc.save
   	end
   end
	# open('image.png', 'wb') do |file|
	#   file << open('http://example.com/image.png').read
	# end

end

task :seed_new_games => :environment do | t, args|
   sorc = Game.new
   sorc.name = "Sorcerer Game"
   sorc.image = "sorcerer_1.png"
   sorc.device_type = 1
   sorc.save

   tfe = Game.new
   tfe.name = "2048"
   tfe.image = "2048.png"
   tfe.save

   bh = Game.new
   bh.name = "Black Hole"
   bh.image = "black_hole.png"
   bh.device_type = 1
   bh.save

   traffic = Game.new
   traffic.name = "Traffic"
   traffic.image = "traffic.png"
   traffic.device_type = 1
   traffic.save

   flappy = Game.new
   flappy.name = "Flappy Pilot"
   flappy.image = "flappy_pilot.png"
   flappy.device_type = 1
   flappy.save

end



#stock names
# burgess_j
# coder19
# mattie_ice
# xfit4life
# bball1818
# hammond9
# lawler
# bigoak1
# overthehill
# nattychamps13
# patsfan87
# task :seed_new_jackpot => :environment do |t,args|
# 	10.times do | i
# end
