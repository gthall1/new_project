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
  
  def faq
  end

  def about
  end

  def contact
  end

  def redeem
  end


end
