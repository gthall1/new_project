class AddTypeToCashout < ActiveRecord::Migration
  def change
    add_column :cash_outs, :cashout_type, :integer
  end
end
