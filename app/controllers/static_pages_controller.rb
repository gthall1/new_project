class StaticPagesController < ApplicationController
  include ApplicationHelper
  
  layout :determine_layout

  def home
     if !signed_in? 
      @current_jackpot = Jackpot.where(open: true).first
      @user = User.new
       if is_mobile?
        render "static_pages/home_mobile"
       end      
     else
      redirect_to games_path
     end
  end
  
  def home_invite
    referred_user_id = User.where(referral:params[:referral]).first
    if referred_user_id
      session[:referred_user_id] = referred_user_id.id
    end
    redirect_to root_path
  end

  def faq
  end

  def about
  end

  def contact
  end

  def redeem
  end


end
