class StaticPagesController < ApplicationController

  def home
     @games = Game.all
  end

  def faq
  end

  def about
  end

  def contact
  end
end
