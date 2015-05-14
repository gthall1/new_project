class UserNotifier < ActionMailer::Base
  default from: "gamemaster@getluckee.com"
  layout 'mailer'

  def send_credit_reminder(args)
  	user = User.where(id:args[:user_id]).first
  	@subject = "Time is running out!"
  	@short_description = "Time is running out! Deposit your credits before it is too late!"
    mail( :to => user.email,
    :subject => "Don't miss out on great prizes!" )
  end
end
