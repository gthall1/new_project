class AddReferredByToArrival < ActiveRecord::Migration
  def change
        add_column :arrivals, :referred_by, :integer
  end
end
