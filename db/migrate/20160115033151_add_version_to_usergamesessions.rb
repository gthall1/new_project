class AddVersionToUsergamesessions < ActiveRecord::Migration
  def change
    add_column :user_game_sessions, :version, :integer
  end
end
