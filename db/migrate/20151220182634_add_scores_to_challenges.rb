class AddScoresToChallenges < ActiveRecord::Migration
  def change
    add_column :challenges, :user_score, :integer
    #add_column :challenges, :challenged_score, :integer
  end
end
