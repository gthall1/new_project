class CreateAdDisplays < ActiveRecord::Migration
  def change
    create_table :ad_displays do |t|
      t.integer :ad_unit_id
      t.float :length
      t.float :value
      t.integer :user_id

      t.timestamps null: false
    end
  end
end
