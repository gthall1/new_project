class ChangePotIdToJackpotId < ActiveRecord::Migration
  def change
  	rename_column :user_entries, :pot_id, :jackpot_id
  end
end
