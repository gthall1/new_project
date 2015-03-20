class AddHighScoreToUserGameSession < ActiveRecord::Migration
  def change
    add_column :user_game_sessions, :score, :integer
  end
end
