class UserNotifier < ActionMailer::Base
  default from: "GetLuckee <gamemaster@getluckee.com>"
  layout 'mailer'

  def send_credit_reminder(args)
  	@user = User.where(id:args[:user_id]).first

  	if @user.credits > 0
  		@head_message = "You have #{@user.credits} credits ready for deposit! Make sure to deposit all of your credits to increase your chances of winning the grand prize of #{Jackpot.where(open:true).last.prize}!"
	    mail( :to => @user.email,
	    :reply_to => 'griffhall1@gmail.com',
	    :display_name => "GetLuckee",
	    :subject => "Don't miss out on great prizes!" )
	end
  end
end
