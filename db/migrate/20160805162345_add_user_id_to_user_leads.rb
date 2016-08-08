class AddUserIdToUserLeads < ActiveRecord::Migration
  def change
    add_column :user_leads, :user_id, :integer
  end
end
