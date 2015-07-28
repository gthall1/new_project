class AddImageToGame < ActiveRecord::Migration
  def change
    add_column :games, :image, :string
  end
end
