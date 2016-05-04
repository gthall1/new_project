class CreateAdUnits < ActiveRecord::Migration
  def change
    create_table :ad_units do |t|
      t.integer :game_id
      t.string :slug
      t.string :name
      t.string :partner
      t.integer :ad_number
      t.float :value

      t.timestamps null: false
    end
  end
end
