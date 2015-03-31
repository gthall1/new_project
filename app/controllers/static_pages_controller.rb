class StaticPagesController < ApplicationController

  def home
     @games = Game.all
     if !signed_in? 
      @user = User.new
     end
     @current_jackpot = Jackpot.where(open: true).first
  end
  
  def faq
  end

  def about
  end

  def contact
  end
end
