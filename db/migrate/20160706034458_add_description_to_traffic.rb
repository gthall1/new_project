class AddDescriptionToTraffic < ActiveRecord::Migration
  def change
    a = Game.find_by_slug('traffic')
    a.description =   "Traffic  --  look both way or you are going to be as flat as a board!  This game require a little bit of luck and a whole lot of good timing.  Navigate across lanes of busy traffic to reach the other side.  How many lanes of traffic can you cross before your luck runs out?"
    a.save 
  end
end
