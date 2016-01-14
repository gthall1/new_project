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
task :add_slug_to_games => :environment do | t, args |
   Game.all.each do | g |
      g.slug = g.name.parameterize
      g.save
   end
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

task :update_game_order => :environment do | t, args |
    g = Game.where(slug:"traffic").first 
    g.sort_order = 1
    g.save
    g = Game.where(slug:"flappy-pilot").first 
    g.sort_order = 2
    g.save
    g = Game.where(slug:"black-hole").first 
    g.sort_order = 3
    g.save
    g = Game.where(slug:"2048").first 
    g.sort_order = 4
    g.save
    g = Game.where(slug:"sorcerer-game").first 
    g.sort_order = 5
    g.save
end

task :add_fall_down => :environment do | t, args |
   fd = Game.new
   fd.name = "Fall Down"
   fd.image = "fall_down.png"
   fd.device_type = 1
   fd.slug = "fall-down"
   fd.sort_order = 2
   fd.save

   set_game_order
   update_images
end

#fixing tracking of initial arrival signup should be a one and done thing
task :fix_arrivals => :environment do | t, args|
   User.where.not(arrival_id:nil).each do | u |
      arrival = Arrival.where(id:u.arrival_id).first
      if arrival && arrival.user_id.blank?
         arrival.user_id = u.id
         arrival.save
      end
   end
end

task :update_images => :environment do |t,args|
   update_images
end

task :update_for_desktop => :environment do|t,args|
 set_device_types
 update_images
end

task :add_tap_color => :environment do |t,args|
   tc = Game.new
   tc.name = "Tap The Right Color"
   tc.desktop_image = "tap_desktop.png"
   tc.device_type = 3
   tc.slug = "tap-color"
   tc.image = "tap_color_mobile.jpg"
   tc.sort_order = 3
   tc.save
end

task :seed_new_games => :environment do | t, args|
   sorc = Game.new
   sorc.name = "Sorcerer Game"
   sorc.image = "sorcerer_1.png"
   sorc.device_type = 1
   sorc.sort_order = 6
   sorc.save

   tfe = Game.new
   tfe.name = "2048"
   tfe.image = "2048.png"
   tfe.sort_order = 4
   tfe.save

   bh = Game.new
   bh.name = "Black Hole"
   bh.image = "black_hole.png"
   bh.device_type = 1
   bh.sort_order = 3
   bh.save

   traffic = Game.new
   traffic.name = "Traffic"
   traffic.image = "traffic.png"
   traffic.device_type = 1
   traffic.sort_order = 1
   traffic.save

   flappy = Game.new
   flappy.name = "Flappy Pilot"
   flappy.image = "flappy_pilot.png"
   flappy.device_type = 1
   flappy.sort_order = 2
   flappy.save

   fd = Game.new
   fd.name = "Fall Down"
   fd.image = "fall_down.png"
   fd.device_type = 1
   fd.slug = "fall-down"
   fd.image = "falldown_mobile.jpg"
   fd.sort_order = 3
   fd.save

   tc = Game.new
   tc.name = "Tap The Right Color"
   tc.desktop_image = "tap_desktop.png"
   tc.device_type = 3
   tc.slug = "tap-color"
   tc.image = "tap_color_mobile.jpg"
   tc.sort_order = 3
   tc.save
end

def set_game_order
    g = Game.where(slug:"traffic").first 
    g.sort_order = 1
    g.save

    g = Game.where(slug:"fall-down").first 
    g.sort_order = 2
    g.save   

    g = Game.where(slug:"flappy-pilot").first 
    g.sort_order = 4
    g.save

    g = Game.where(slug:"black-hole").first 
    g.sort_order = 3
    g.save

    g = Game.where(slug:"2048").first 
    g.sort_order = 5
    g.save

    g = Game.where(slug:"sorcerer-game").first 
    g.sort_order = 6
    g.save  

    g = Game.where(slug:"tap-color").first 
    g.sort_order = 7
    g.save      
end

def set_device_types
    g = Game.where(slug:"traffic").first 
    g.device_type = 3
    g.save

    g = Game.where(slug:"fall-down").first 
    g.device_type = 3
    g.save   

    g = Game.where(slug:"flappy-pilot").first 
    g.device_type = 3
    g.save

    g = Game.where(slug:"black-hole").first 
    g.device_type = 3
    g.save

    g = Game.where(slug:"2048").first 
    g.device_type = 3
    g.save

    g = Game.where(slug:"sorcerer-game").first 
    g.device_type = 1
    g.save  

    g = Game.where(slug:"tap-color").first 
    g.device_type = 3
    g.save     
end


def update_images
    g = Game.where(slug:"traffic").first 
    g.image = "bigger_traffic.png"
    g.desktop_image ="square_traffic.png"
    g.save

    g = Game.where(slug:"fall-down").first 
    g.image = "falldown_mobile.jpg"
    g.desktop_image ="square_fall_down.png"    
    g.save   

    g = Game.where(slug:"flappy-pilot").first 
    g.image = "bigger_flappy_pilot.png"
    g.desktop_image ="square_flappy.png"    
    g.save

    g = Game.where(slug:"black-hole").first 
    g.image = "bigger_black_hole.png"
    g.desktop_image ="square_black_hole.png"    
    g.save

    g = Game.where(slug:"2048").first 
    g.image = "bigger_2048.png"
    g.desktop_image ="square_2048.png"
    g.save

    g = Game.where(slug:"sorcerer-game").first 
    g.image = "bigger_sorcerer.png"
    g.desktop_image ="square_sorcerer.png"    
    g.save 
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
