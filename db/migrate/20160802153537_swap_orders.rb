class SwapOrders < ActiveRecord::Migration
  def change

    fd = Game.where(slug:'fall-down').first
    fd.sort_order = 6
    fd.save

    fp = Game.where(slug:'flappy-pilot').first
    fp.sort_order = 5
    fp.save

  end
end
