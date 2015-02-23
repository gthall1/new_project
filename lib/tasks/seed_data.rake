task :seed_data => :environment do |t,args|
	testgame = Game.new
	testgame.name = "Test"
	testgame.save
	
	heligame = Game.new
	heligame.name = "Helicopter"
	heligame.save

	jackpot = Jackpot.new
	jackpot.name = "Test"
	jackpot.draw_date = Time.now + 2.months
	jackpot.open = true
	jackpot.prize = "$100 visa giftcard"
	jackpot.max_entries = 500
	jackpot.save
end