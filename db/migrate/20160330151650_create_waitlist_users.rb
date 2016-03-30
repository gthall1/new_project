class CreateWaitlistUsers < ActiveRecord::Migration
  def change
    create_table :waitlist_users do |t|
      t.string :email
      t.integer :arrival_id

      t.timestamps null: false
    end
  end
end
