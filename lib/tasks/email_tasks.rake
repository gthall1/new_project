task :send_almost_full_email => :environment do |t,args|
	User.all.each do | u |
		UserNotifier.send_credit_reminder({user_id:u.id}).deliver
	end
end