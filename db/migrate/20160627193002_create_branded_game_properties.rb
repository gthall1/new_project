class CreateBrandedGameProperties < ActiveRecord::Migration
  def change
    create_table :branded_game_properties do |t|
      t.integer :game_id
      t.integer :advertiser_id
      t.string :branded_game_name
      t.string :branded_game_image_m
      t.string :branded_game_image_d

      t.timestamps null: false
    end
  end
end
