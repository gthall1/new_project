class AddUserLeadIdToUsers < ActiveRecord::Migration
  def change
    add_column :users, :user_lead_id, :integer
  end
end
