class CreateUserGameSessions < ActiveRecord::Migration
  def change
    create_table :user_game_sessions do |t|
      t.string :token
      t.integer :user_id
      t.integer :game_id
      t.integer :credits_earned
      t.boolean :active

      t.timestamps
    end
  end
end
