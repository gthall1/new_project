class AddPendingCreditsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :pending_credits, :integer
  end
end
