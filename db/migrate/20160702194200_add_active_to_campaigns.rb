class AddActiveToCampaigns < ActiveRecord::Migration
  def change
    add_column :campaigns, :active, :boolean
  end
end
