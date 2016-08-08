class CreateUserLeads < ActiveRecord::Migration
  def change
    create_table :user_leads do |t|
      t.string :username
      t.string :email
      t.boolean :verified

      t.timestamps null: false
    end
  end
end
