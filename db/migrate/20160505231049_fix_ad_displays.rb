class FixAdDisplays < ActiveRecord::Migration
  def change
    create_table :ad_displays do |t|
      t.integer :ad_number
      t.integer :user_id
      t.integer :user_game_session_id
      t.integer :game_id
    end
  end
end
