class CreatePurchases < ActiveRecord::Migration
  def change
    create_table :purchases do |t|
      t.integer :user_id
      t.integer :purchase_type
      t.integer :purchase_record_id
      t.integer :credits_spent

      t.timestamps null: false
    end
  end
end
