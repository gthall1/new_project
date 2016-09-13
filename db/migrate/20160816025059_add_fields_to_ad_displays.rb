class AddFieldsToAdDisplays < ActiveRecord::Migration
  def change
    add_column :ad_displays, :campaign_id, :integer
    add_column :ad_displays, :global_visitor_id, :string
    add_column :ad_displays, :arrival_id, :integer
  end
end
