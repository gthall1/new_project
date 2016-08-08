class AddUserLeadIdToArrivals < ActiveRecord::Migration
  def change
    add_column :arrivals, :user_lead_id, :integer
  end
end
