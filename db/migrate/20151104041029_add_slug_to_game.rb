class AddSlugToGame < ActiveRecord::Migration
  def change
  	add_column :games, :slug, :string   
  end
end
