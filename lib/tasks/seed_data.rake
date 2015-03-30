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