class CreateChallenges < ActiveRecord::Migration
  def change
    create_table :challenges do |t|
      t.integer :user_id
      t.integer :challenged_id
      t.integer :game_id
      t.integer :winner_id
      t.integer :challenger_score
      t.integer :challenged_score

      t.timestamps null: false
    end
  end
end
