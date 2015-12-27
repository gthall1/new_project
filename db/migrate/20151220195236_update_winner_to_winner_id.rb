class UpdateWinnerToWinnerId < ActiveRecord::Migration
  def change
  	rename_column :challenges, :winner, :winner_id
  end
end
