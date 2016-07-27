class GetGamesInSync < ActiveRecord::Migration
  def change
    Game.where.not(slug:['traffic','flappy-pilot','2048','match-three','gold-runner','fall-down']).each do | g | 
        g.device_type = nil
        g.save
    end
  end
end
