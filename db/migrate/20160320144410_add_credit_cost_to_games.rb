class AddCreditCostToGames < ActiveRecord::Migration
  def change
    add_column :games, :credit_cost, :integer
  end
end
