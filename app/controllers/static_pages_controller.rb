class StaticPagesController < ApplicationController

  def home
     @games = Game.all
     @current_jackpot = Jackpot.where(open: true).first
  end
  
  def faq
  end

  def about
  end

  def contact
  end
end
