class AddCreditsAppliedToGameSessions < ActiveRecord::Migration
  def change
    add_column :user_game_sessions, :credits_applied, :integer, :default => 0
  end
end
