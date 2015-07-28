class AddCreditsAndLifetimeCreditsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :lifetime_credits, :integer
  end
end
