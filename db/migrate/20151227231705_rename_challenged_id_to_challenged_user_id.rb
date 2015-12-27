class RenameChallengedIdToChallengedUserId < ActiveRecord::Migration
  def change
  	rename_column :challenges, :challenged_id, :challenged_user_id
  end
end
