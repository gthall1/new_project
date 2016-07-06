class AddDescriptionToGames < ActiveRecord::Migration
  def change
    add_column :games, :description, :string
  end
end
