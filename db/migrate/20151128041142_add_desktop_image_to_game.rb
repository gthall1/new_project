class AddDesktopImageToGame < ActiveRecord::Migration
  def change
    add_column :games, :desktop_image, :string
  end
end
