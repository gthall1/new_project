require 'rake'

task :send_almost_full_email => :environment do |t,args|
	#had an issue here already sent ot these 4
	already_sent = ['mnoto@phillipvhomes.com','krawltoy22@gmail.com','nick.kennemur@gmail.com','chasebrook@aol.com','chasebrook2@yahoo.com']
	User.all.each do | u |
		begin
			if !already_sent.include?(u.email)
				UserNotifier.send_credit_reminder({user_id:u.id}).deliver
			end
		rescue
			p "An error occured with #{u.id}"
		end
	end
end
