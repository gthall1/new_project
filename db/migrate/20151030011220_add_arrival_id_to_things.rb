class AddArrivalIdToThings < ActiveRecord::Migration
  def change
  	add_column :users, :arrival_id, :integer  
  	add_column :user_game_sessions, :arrival_id, :integer   
  	add_column :cash_outs, :arrival_id, :integer   
    add_column :surveys, :arrival_id, :integer   

  end
end
