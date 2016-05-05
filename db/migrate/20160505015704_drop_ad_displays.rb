class DropAdDisplays < ActiveRecord::Migration
  def change
    drop_table :ad_displays
  end
end
