class AddIndexesToUserGameSessions < ActiveRecord::Migration
  def change
        add_index :user_game_sessions, :user_id
        add_index :user_game_sessions, :game_id
        add_index :user_game_sessions, :arrival_id
        add_index :user_game_sessions, :created_at
        add_index :user_game_sessions, :updated_at
  end
end
