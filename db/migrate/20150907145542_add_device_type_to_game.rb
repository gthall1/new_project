class AddDeviceTypeToGame < ActiveRecord::Migration
  def change
    add_column :games, :device_type, :integer
  end
end
