class UserNotifier < ActionMailer::Base
  default from: "Luckee <gamemaster@getluckee.com>"
 # default from: "Griff Hall via Luckee <griffhall1@gmail.com>"

  def send_credit_reminder(args)
  	@user = User.where(id:args[:user_id]).first

  	if @user && !@user.credits.blank? && @user.credits > 0
  		@head_message = "You have #{@user.credits} credits ready for deposit! Make sure to deposit all of your credits to increase your chances of winning the grand prize of #{Jackpot.where(open:true).last.prize}!"
	    mail( :to => @user.email,
	    :reply_to => 'griffhall1@gmail.com',
	    :display_name => "GetLuckee",
	    :subject => "Don't miss out on great prizes!" )
	  end
  end

  def send_welcome_email(args)
    @user = User.where(id:args[:user_id]).first

    if @user 
      mail( :to => @user.email,
      :reply_to => 'griffhall1@gmail.com',
      :from => 'Griff Hall via Luckee <griffhall1@gmail.com>',
      :display_name => "Luckee",
      :subject => "Thanks for checking out Luckee!" )
    end
  end  

  def password_reset(user)
    @user = user
    mail(to: user.email,:display_name => "Luckee", subject: "Password reset")
  end

end
