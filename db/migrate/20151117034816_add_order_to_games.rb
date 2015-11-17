class AddOrderToGames < ActiveRecord::Migration
  def up
  	 add_column :games, :sort_order, :integer   
  end
  def down

  end
end


