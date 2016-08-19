class AddGlobalVisitorIdToArrivals < ActiveRecord::Migration
  def change
    add_column :arrivals, :global_visitor_id, :string
  end
end
