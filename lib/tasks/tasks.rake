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
