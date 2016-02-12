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
      :from => 'Griff Hall via Luckee <griff@getluckee.com>',
      :display_name => "Luckee",
      :subject => "Thanks for checking out Luckee!" )
    end
  end

  def send_cash_out_email(args)
    @user = User.where(id:args[:user_id]).first
    @cash_out = @user.cash_outs.last
    if @user
      mail( :to => "tylerrules@gmail.com,griffhall1@gmail.com,alexmorgan.am@gmail.com",
      :from => 'Lughee MgLuck <support@getluckee.com>',
      :display_name => "Luckee",
      :subject => "Someone is Cashing out on Luckee!" )
    end
  end

  def send_confirmation_email(args)
    @user = User.where(id:args[:user_id]).first

    if @user
      mail( :to => @user.email,
      :reply_to => 'griffhall1@gmail.com',
      :from => 'Griff Hall via Luckee <griff@getluckee.com>',
      :display_name => "Luckee",
      :subject => "Luckee: Confirm Email" )
    end
  end

  def send_donation_email(args)
    @user = User.where(id:args[:user_id]).first
    @cash_out = @user.cash_outs.last
    if @user
      mail( :to => "tylerrules@gmail.com,griffhall1@gmail.com,alexmorgan.am@gmail.com",
      :from => 'Lughee MgLuck <support@getluckee.com>',
      :display_name => "Luckee",
      :subject => "Someone is making a donation on Luckee!" )
    end
  end

  def send_challenge_email(args)
    @challenger = User.where(id:args[:challenger_id]).first
    @user = User.where(id:args[:user_id]).first
    @challenge_game = args[:game_name]
    if @user
      mail( :to => @user.email,
      :from => "Challenges via Luckee <support@getluckee.com>",
      :display_name => "Luckee",
      :subject => "Someone is challenging you to #{@challenge_game}!" )
    end
  end

  def password_reset(user)
    @user = user
    mail(to: user.email,:display_name => "Luckee", subject: "Password reset")
  end

end
