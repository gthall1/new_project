class CreateBrandedGameAssets < ActiveRecord::Migration
  def change
    create_table :branded_game_assets do |t|
      t.string :name
      t.string :description
      t.integer :width
      t.integer :height
      t.string :slug
      t.integer :game_id
      t.integer :campaign_id
      t.string :asset_url

      t.timestamps null: false
    end
  end
end
