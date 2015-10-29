class CreateCashOuts < ActiveRecord::Migration
  def change
    create_table :cash_outs do |t|
      t.integer :user_id
      t.integer :credits
      t.integer :cash
      t.string :venmo
      t.string :paypal

      t.timestamps
    end
  end
end
