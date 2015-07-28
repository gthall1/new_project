class AddChallengeToGameSession < ActiveRecord::Migration
  def change
    add_column :user_game_sessions, :challenge_id, :integer
  end
end
