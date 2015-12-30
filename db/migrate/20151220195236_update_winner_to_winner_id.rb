class UpdateWinnerToWinnerId < ActiveRecord::Migration
  def change
  	rename_column :challenges, :challenger_id, :user_id
    remove_column :challenges, :challenger_score
  end
end
