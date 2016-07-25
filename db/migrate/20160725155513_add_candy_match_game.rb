class AddCandyMatchGame < ActiveRecord::Migration
  def change
    candy = Game.new
    candy.name = "Candy Match 3"
    candy.image = "candy_mobile.png"
    candy.desktop_image = "candy_desktop.png"
    candy.device_type = 3
    candy.slug = "match-three"
    candy.sort_order = 1
    candy.save

    a = Game.where(slug:'gold-runner').first
    a.sort_order = 2
    a.save

    a = Game.where(slug:'2048').first
    a.sort_order = 3
    a.save

    a =  Game.where(slug:'traffic').first
    a.sort_order = 4
    a.save

    a =  Game.where(slug:'fall-down').first
    a.sort_order = 5
    a.save

    a =  Game.where(slug:'flappy-pilot').first
    a.sort_order = 6
    a.save

    a =  Game.where(slug:'tap-color').first
    a.device_type = nil
    a.save

  end
end
