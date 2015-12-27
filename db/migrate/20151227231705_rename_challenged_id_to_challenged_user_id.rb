class RenameChallengedIdToChallengedUserId < ActiveRecord::Migration
  def change
  	rename_column :challenges, :challenger_id, :challenged_user_id
  end
end
