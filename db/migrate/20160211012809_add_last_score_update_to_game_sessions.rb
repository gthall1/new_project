class AddLastScoreUpdateToGameSessions < ActiveRecord::Migration
  def change
    add_column :user_game_sessions, :last_score_update, :datetime
  end
end
