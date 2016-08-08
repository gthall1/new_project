class AddArrivalIdToUserLeads < ActiveRecord::Migration
  def change
    add_column :user_leads, :arrival_id, :integer
  end
end
