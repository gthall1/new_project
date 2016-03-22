class RenameColumnPurchaseType < ActiveRecord::Migration
  def change
        rename_column :purchases, :purchase_type, :purchase_type_id
  end
end
