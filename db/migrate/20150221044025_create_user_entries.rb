class CreateUserEntries < ActiveRecord::Migration
  def change
    create_table :user_entries do |t|
      t.integer :user_id
      t.integer :pot_id

      t.timestamps
    end
  end
end
